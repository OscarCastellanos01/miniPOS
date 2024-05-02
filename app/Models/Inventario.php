<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventario extends Model
{
    use HasFactory;

    protected $table = 'tbl_inventario';
    protected $primaryKey = 'inventario_id';
    public $timestamps = false;
}
