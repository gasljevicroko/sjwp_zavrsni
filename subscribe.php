<?php
include 'config.php';
session_start();

if (isset($_GET['podcast_id']) && isset($_SESSION['user_id'])) {
    $p_id = $_GET['podcast_id'];
    $u_id = $_SESSION['user_id'];

    // Provjeri postoji li već pretplata
    $check = $pdo->prepare("SELECT * FROM subscription WHERE user_ID = ? AND podcast_ID = ?");
    $check->execute([$u_id, $p_id]);

    if ($check->rowCount() > 0) {
        // Ako postoji, obriši je (Unsubscribe)
        $del = $pdo->prepare("DELETE FROM subscription WHERE user_ID = ? AND podcast_ID = ?");
        $del->execute([$u_id, $p_id]);
    } else {
        // Ako ne postoji, dodaj je (Subscribe)
        $ins = $pdo->prepare("INSERT INTO subscription (user_ID, podcast_ID, subscribed_at) VALUES (?, ?, NOW())");
        $ins->execute([$u_id, $p_id]);
    }
    header("Location: podcast_details.php?id=" . $p_id);
}