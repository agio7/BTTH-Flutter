<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Lấy danh sách tất cả sản phẩm.
     */
    public function index()
    {
        return Product::all(); // [cite: 90, 91, 92]
    }

    /**
     * Tạo một sản phẩm mới.
     */
    public function store(Request $request)
    {
        $request->validate([ // [cite: 97]
            'name' => 'required|string|max:255', // [cite: 98]
            'price' => 'required|numeric', // [cite: 99]
        ]);

        $product = Product::create($request->all()); // [cite: 102, 103]

        return response()->json($product, 201); // [cite: 104]
    }

    /**
     * Lấy thông tin một sản phẩm cụ thể.
     */
    public function show(Product $product)
    {
        return $product; // [cite: 106, 107, 108]
    }

    /**
     * Cập nhật thông tin sản phẩm.
     */
    public function update(Request $request, Product $product)
    {
        $request->validate([ // [cite: 113]
            'name' => 'string|max:255', // [cite: 115]
            'price' => 'numeric', // [cite: 116]
        ]);

        $product->update($request->all()); // [cite: 117]

        return response()->json($product, 200); // [cite: 118]
    }

    /**
     * Xóa một sản phẩm.
     */
    public function destroy(Product $product)
    {
        $product->delete(); // [cite: 121, 122, 123]

        return response()->json(null, 204); // [cite: 124]
    }
}