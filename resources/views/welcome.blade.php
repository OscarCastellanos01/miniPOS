<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="{{ asset('assets/css/bootstrap.css') }}">
    </head>
    <body>
        <div class="container mt-5">
            @if (session('mensaje'))
                <div role="alert" class="alert alert-success">
                    <span>{{ session('mensaje') }}.</span>
                </div>
            @endif
            <form action="{{ route('addToCart') }}" method="POST">
                @csrf
                <div>
                    <label for="producto_id">Producto ID</label>
                    <input type="text" class="form-control" name="producto_id" id="producto_id" value="{{ old('producto_id') }}">
                    @error('producto_id')
                        <strong>{{$message}}</strong>
                    @enderror
                </div>
                <div>
                    <label for="almacen_id">Almacen ID</label>
                    <input type="text" class="form-control" name="almacen_id" id="almacen_id" value="{{ old('almacen_id') }}">
                    @error('almacen_id')
                        <strong>{{ $message }}</strong>
                    @enderror
                </div>
                <div>
                    <label for="cantidad">Cantidad a vender</label>
                    <input type="text" class="form-control" name="cantidad" id="cantidad" value="{{ old('cantidad') }}">
                    @error('cantidad')
                        <strong>{{ $message }}</strong>
                    @enderror
                </div>
                <div class="mt-3">
                    <button
                        type="submit"
                        class="btn btn-outline-primary"
                    >
                        Ingresar producto
                    </button>
                    
                </div>
            </form>
        </div>
        <div class="container mt-5">
            <form action="{{ route('saveCart') }}" method="POST">
                @csrf
                <button
                        type="submit"
                        class="btn btn-outline-success"
                    >
                        Guardar carrito
                    </button>
            </form>

            <table class="table shadow-xl">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Almacen</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse (Cart::content() as $cart)
                        <tr class="hover">
                            <td>
                                <p>
                                    <strong>{{ $cart->name }}</strong>
                                </p>
                            </td>
                            <td>
                                {{ $cart->qty }}
                            </td>            
                            <td>Q.{{ $cart->price }}</td>
                            <td>{{ $cart->options->almacenId  }}</td>
                            <td>Q.{{ $cart->subtotal }}</td>
                        </tr>
                    @empty
                        <tr class="text-center">
                            <td colspan="5" class="text-xl">CARRITO VACIO</td>
                        </tr>
                    @endforelse
                </tbody>
                <tfoot>
                    @if (Cart::subtotal() > 0)
                        <tr>
                            <td colspan="3">&nbsp;</td>
                            <td class="text-base">Subtotal</td>
                            <td class="text-base">{{ Cart::subtotal() }}</td>
                        </tr>
                    @endif
                </tfoot>
            </table>
        </div>
    </body>
</html>
