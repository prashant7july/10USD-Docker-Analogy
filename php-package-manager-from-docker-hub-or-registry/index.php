<?php 

require_once 'vendor/autoload.php';
use Zend\Crypt\Password\Bcrypt;

$bcrypt = new Bcrypt(); 
echo $password = $bcrypt->create("test"); 