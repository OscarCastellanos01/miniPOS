<?php

namespace App\Http\Controllers;

use App\Models\DetalleVenta;
use App\Models\Inventario;
use App\Models\Producto;
use App\Models\Venta;
use Gloudemans\Shoppingcart\Facades\Cart;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CartController extends Controller
{
    public function addToCart(Request $request)
    {
        $this->validate($request, [
            'producto_id' => 'required',
            'almacen_id' => 'required',
            'cantidad' => 'required'
        ]);

        // Consulta a la tabla de productos
        $producto = Producto::find($request->producto_id);

        // dd($producto);

        // Validar stock antes de agregarlo al carrito
        $stock = Inventario::where('producto_id', $request->producto_id)
                   ->where('almacen_id', $request->almacen_id)
                   ->value('stock_inventario');

        if ($request->cantidad > $stock) {
            return back()->with('mensaje', "No hay suficiente stock para: " . $producto->descripcion_producto . ", Stock actual: " . $stock);
        }

        // Agregar el producto al carrito
        Cart::add(
            $request->producto_id, 
            $producto->descripcion_producto, 
            $request->cantidad, 
            $producto->precio_venta_producto, 
            ['almacenId' => $request->almacen_id]
        );

        return redirect()->route('home')->with('mensaje', "El producto se agrego al carrito");
    }

    public function saveCart()
    {
        // Obtener productos en el carrito
        $cartItems = Cart::content();
        
        if($cartItems->count() === 0)
        {
            return back()->with('mensaje', 'Aún no se ha agregado ningún artículo al carrito');
        }

        // Validar el stock antes de procesar la orden
        foreach ($cartItems as $cartItem) {
            $producto = Producto::find($cartItem->id);

            $stock = Inventario::where('producto_id', $cartItem->id)
                   ->where('almacen_id', $cartItem->options->almacenId)
                   ->value('stock_inventario');
            if ($cartItem->qty > $stock) {
                return back()->with('mensaje', "No hay suficiente stock para: " . $producto->descripcion_producto . ", Stock actual: " . $stock);
            }
        }
    
        DB::beginTransaction();

        try {
            // Almacenar venta
            $venta = new Venta;
            $venta->unidades_venta = Cart::count();
            $venta->tipo_documento_id = 1;
            $venta->documento_venta = 2;
            $venta->cliente_id = 1;
            $venta->medio_pago_id = 1;
            $venta->monto_total_venta = Cart::subtotal();
            $venta->condicion_venta = 1;
            $venta->save();
        
            // Obtener el ID de la venta
            $venta_id = $venta->venta_id;
        
            // Formatear arreglo
            $orderDetails = [];
        
            // almacenar detalles de la  venta
            foreach ($cartItems as $cartItem) {
                $producto = Producto::find($cartItem->id);
        
                // Almacenar detalles de la venta
                $orderDetails[] = [
                    'venta_id' => $venta_id,
                    'producto_id' => $producto->producto_id,
                    'almacen_id' => $cartItem->options->almacenId,
                    'cantidad' => $cartItem->qty,
                ];
            }
        
            // Almacenar detalles de la venta en la BD
            DetalleVenta::insert($orderDetails);
        
            // Eliminar carrito
            Cart::destroy();
            
            DB::commit();
            return redirect()->route('home')->with('mensaje', "Venta realizada correctamente");
        } catch (\Exception $e) {
            DB::rollback();
            return back()->with('mensaje', 'ERROR al guradar el carrito. '. $e);
        }
        
    }
}
