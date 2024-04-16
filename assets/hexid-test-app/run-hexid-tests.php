<?php

require __DIR__ . '/vendor/autoload.php';

use \Mattifesto\HexID\HexID;
use \Mattifesto\HexID\Size;

$hexID = HexID::generateRandom(Size::bits160);

echo "Generated 160-bit HexID: $hexID\n";

$hexID = HexID::generateRandom(Size::bits256);

echo "Generated 256-bit HexID: $hexID\n";
