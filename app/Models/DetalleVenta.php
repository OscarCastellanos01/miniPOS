<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetalleVenta extends Model
{
    use HasFactory;
    
    protected $table = 'tbl_DetalleVentas';
    protected $primaryKey = 'detalle_venta_id';
    public $timestamps = false;
}
