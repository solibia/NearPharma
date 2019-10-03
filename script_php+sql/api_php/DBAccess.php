<?php
require('dbconfig.php');
	//***********@uthor Basile PAZIMNA*****************//	
class Access{
    private $access;

    public function DBAccess(){
        $dns = "pgsql:host=".Settings::host.";port=".Settings::port.";dbname=".Settings::db.";user=".Settings::username.";password=".Settings::password;
        try{
            $this->access = new PDO($dns);
           return $this->access;
          //return 0;
	}catch(Exception $e){
            echo "Accès impossible à la base de données!", $e->getMessage();
           // die();
        }
        return 1;
    }
}
