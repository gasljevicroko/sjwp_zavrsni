
<?php
include 'config.php';
session_start();
if (!isset($_SESSION['user_id'])) header("Location: login.php");

$id = $_GET['id'];
$current_user_id = $_SESSION['user_id'];

// --- OBRADA RECENZIJE (Usklađeno s tvojom bazom 'podwaveprava') ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['submit_review'])) {
    $episode_id = $_POST['episode_id'];
    $rating = $_POST['rating'];
    $comment = $_POST['comment'];

    // Provjera postoji li već recenzija
    $check = $pdo->prepare("SELECT * FROM review WHERE user_ID = ? AND episode_ID = ?");
    $check->execute([$current_user_id, $episode_id]);
    
    if ($check->rowCount() == 0) {
        $ins = $pdo->prepare("INSERT INTO review (user_ID, episode_ID, rating, comment, review_date) VALUES (?, ?, ?, ?, NOW())");
        $ins->execute([$current_user_id, $episode_id, $rating, $comment]);
        echo "<script>alert('Recenzija objavljena!'); window.location.href='podcast_details.php?id=$id';</script>";
    } else {
        echo "<script>alert('Već ste ocijenili ovu epizodu!');</script>";
    }
}

// Dohvati podatke
$stmt = $pdo->prepare("SELECT * FROM podcast WHERE ID_podcast = ?");
$stmt->execute([$id]);
$podcast = $stmt->fetch();

$stmt = $pdo->prepare("SELECT * FROM episode WHERE podcast_ID = ? ORDER BY episode_number ASC");
$stmt->execute([$id]);
$episodes = $stmt->fetchAll();

// Provjera je li korisnik već pretplaćen
$sub_stmt = $pdo->prepare("SELECT * FROM subscription WHERE user_ID = ? AND podcast_ID = ?");
$sub_stmt->execute([$current_user_id, $id]);
$is_subscribed = $sub_stmt->rowCount() > 0;
?>

<!DOCTYPE html>
<html lang="hr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($podcast['title']) ?></title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar">
    <div class="container nav-container">
        <a class="navbar-brand" href="index.php">PODWAVE</a>
        <div class="nav-actions">
            <a href="index.php" class="btn btn-outline btn-sm">Natrag</a>
        </div>
    </div>
</nav>

<main class="container details-layout">
    <div class="details-sidebar">
        <?php $img = !empty($podcast['cover_image_url']) ? $podcast['cover_image_url'] : 'img/default_cover.png'; ?>
        <img src="<?= $img ?>" class="details-cover">
        
        <h1 class="details-title"><?= htmlspecialchars($podcast['title']) ?></h1>
        
        <a href="subscribe.php?podcast_id=<?= $id ?>" 
           class="btn <?= $is_subscribed ? 'btn-outline' : 'btn-primary' ?> btn-full mt-3">
            <?= $is_subscribed ? '✓ Pretplatili ste se' : '+ Pretplati se' ?>
        </a>
    </div>

    <div class="details-content">
        <section class="podcast-info">
            <h3>O podcastu</h3>
            <p class="text-muted"><?= htmlspecialchars($podcast['description']) ?></p>
        </section>
        
        <hr class="divider">
        
        <section class="episodes-section">
            <h4>Epizode</h4>
            <?php foreach ($episodes as $ep): ?>
                <div class="episode-card">
                    <div class="episode-header">
                        <div class="episode-info">
                            <h5>Ep <?= $ep['episode_number'] ?>: <?= htmlspecialchars($ep['title']) ?></h5>
                            <p class="text-muted small"><?= htmlspecialchars($ep['description']) ?></p>
                        </div>
                        <button class="btn btn-success px-4">POKRENI</button>
                    </div>
                    
                    <div class="reviews-section">
                        <h6 class="reviews-heading">Recenzije:</h6>
                        <?php
                        $rev_stmt = $pdo->prepare("SELECT r.*, u.name FROM review r JOIN user u ON r.user_ID = u.ID_user WHERE r.episode_ID = ?");
                        $rev_stmt->execute([$ep['ID_episode']]);
                        while ($rev = $rev_stmt->fetch()): ?>
                            <div class="review-item">
                                <span class="stars"><?= str_repeat("★", $rev['rating']) ?></span>
                                <strong class="review-author"><?= htmlspecialchars($rev['name']) ?>:</strong> 
                                <span class="review-text"><?= htmlspecialchars($rev['comment']) ?></span>
                            </div>
                        <?php endwhile; ?>
                    </div>

                    <button class="btn-link mt-2" onclick="document.getElementById('f-<?= $ep['ID_episode'] ?>').classList.toggle('hidden-form')">
                        Napiši recenziju
                    </button>
                    
                    <div id="f-<?= $ep['ID_episode'] ?>" class="hidden-form mt-3">
                        <form method="POST" class="review-form">
                            <input type="hidden" name="episode_id" value="<?= $ep['ID_episode'] ?>">
                            <div class="mb-2">
                                <select name="rating" class="form-select">
                                    <option value="5">5 zvjezdica</option>
                                    <option value="4">4 zvjezdice</option>
                                    <option value="3">3 zvjezdice</option>
                                    <option value="2">2 zvjezdice</option>
                                    <option value="1">1 zvjezdica</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <textarea name="comment" class="form-input" placeholder="Tvoj komentar..." required></textarea>
                            </div>
                            <button type="submit" name="submit_review" class="btn btn-primary btn-sm">Objavi recenziju</button>
                        </form>
                    </div>
                </div>
            <?php endforeach; ?>
        </section>
    </div>
</main>

</body>
</html>
