<?php
$mysqli = new mysqli("dimdim-bd", "dimuser", "dimpass", "dimdimdb");
if ($mysqli->connect_error) {
    die("Erro na conexão: " . $mysqli->connect_error);
}
echo "Conectado com sucesso ao Banco DimDim!";
?>