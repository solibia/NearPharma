<?php
header('Content-type:text/xml');
echo '<?xml version="1.0" encoding="utf-8"?>';	
echo '<pharma>';
require('fonction.php');

ini_set('max_execution_time', 300);

((isset($_GET['latitude']) && !empty($_GET['latitude'])) ? $latitude = $_GET['latitude'] : $latitude = '');
((isset($_GET['longitude']) && !empty($_GET['longitude'])) ? $longitude = $_GET['longitude'] : $longitude = '');

if($latitude != "" && $longitude != "" ){

	$data = getPharmacie($latitude, $longitude);
	foreach($data as $row) {
		echo '<item>';
			echo '<id>';
				echo $row->getId();
			echo '</id>';
			echo '<nom>';
				echo "<![CDATA[".$row->getName()."]]>";
			echo '</nom>';			
			echo '<latitude>';
				echo $row->getLatitude();
			echo '</latitude>';
			echo '<longitude>';
				echo $row->getLongitude();
			echo '</longitude>';
			echo '<telephone>';
				echo $row->getTelephone();
			echo '</telephone>';
			echo '<rue>';
				echo "<![CDATA[".$row->getRue()."]]>";
			echo '</rue>';
		echo "</item>";
	}
}
echo '</station>';
?>
