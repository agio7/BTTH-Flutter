<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory; // [cite: 66]

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [ // [cite: 67]
        'name', // [cite: 69]
        'description', // [cite: 70]
        'price', // [cite: 71]
    ];
}