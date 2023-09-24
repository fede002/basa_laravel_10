<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller as ControllersController;
use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class AppController extends ControllersController
{
    use AuthorizesRequests, ValidatesRequests;

    public function login(Request $rq){
        $data = ["saludo" => "Hola que tal"];
        return view('sitio/app',$data);
    }
}
