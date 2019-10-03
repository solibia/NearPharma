<?php
require_once('DBAccess.php');
require_once('pharma.php');

function getPharmacie($lng, $lat){
	$request = "select * from getnearpharmacies('$lng', '$lat')";
	$access = new Access();
	$db = $access->DBAccess();
	$results = $db->query($request);
	$results->setFetchMode(PDO::FETCH_ASSOC);
	$results->execute();

	$pharmacie[] = null;

	$rows = $results->fetchAll();
	$i = 0;
	foreach($rows as $row) {

 		$pharmacie[$i] = new Pharmacie();
		$pharmacie[$i]->setId($row['idpharma']);
		$pharmacie[$i]->setName($row['nompharma']);
		$pharmacie[$i]->setLatitude($row['latitude']);
		$pharmacie[$i]->setLongitude($row['longitude']);
		$pharmacie[$i]->setTelephone($row['telpharma']);
		$pharmacie[$i]->setRue($row['addrpharma']);
		$i = $i+1;
	}
	return $pharmacie;
}
?>
