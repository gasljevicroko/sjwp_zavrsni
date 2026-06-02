
<?php 
include 'config.php';
session_start();
if (!isset($_SESSION['user_id'])) header("Location: login.php");

$search = isset($_GET['q']) ? $_GET['q'] : '';
$user_id = $_SESSION['user_id'];
?>
<!DOCTYPE html>
<html lang="hr">
<head>
    <meta charset="UTF-8">
    <title>PodWave - Slušaj</title>
    <link rel="icon" type="image/x-icon" href="p-icon.ico">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar">
    <div class="container nav-container">
        <a class="navbar-brand" href="index.php">PODWAVE</a>
        
        <div class="nav-search-section">
            <form class="search-form" method="GET">
                <input name="q" class="form-input" type="search" placeholder="Pretraži..." value="<?= htmlspecialchars($search) ?>">
                <button class="btn btn-primary" type="submit">Traži</button>
            </form>

            <div class="dropdown">
                <button class="btn btn-outline" type="button" id="subsDropdownBtn">
                    Pratim
                </button>
                <ul class="dropdown-menu" id="subsDropdownMenu">
                    <li class="dropdown-header">
                        <h6>Moji kanali</h6>
                    </li>
                    <?php
                    $sub_query = "SELECT p.* FROM podcast p 
                                  JOIN subscription s ON p.ID_podcast = s.podcast_ID 
                                  WHERE s.user_ID = ?";
                    $sub_stmt = $pdo->prepare($sub_query);
                    $sub_stmt->execute([$user_id]);
                    $my_subs = $sub_stmt->fetchAll();

                    if ($my_subs):
                        foreach ($my_subs as $sub): 
                            $sub_img = !empty($sub['cover_image_url']) ? $sub['cover_image_url'] : 'img/default_cover.png';
                        ?>
                            <li>
                                <a class="dropdown-item" href="podcast_details.php?id=<?= $sub['ID_podcast'] ?>">
                                    <img src="<?= $sub_img ?>" class="avatar-img">
                                    <span class="text-truncate"><?= $sub['title'] ?></span>
                                </a>
                            </li>
                        <?php endforeach;
                    else: ?>
                        <li class="dropdown-empty">Još nikoga ne pratiš.</li>
                    <?php endif; ?>
                </ul>
            </div>
        </div>

        <div class="nav-actions">
            <?php if ($_SESSION['is_creator']): ?>
                <a href="creator_dashboard.php" class="btn btn-warning">Creator</a>
            <?php endif; ?>
            <a href="logout.php" class="btn btn-danger">Odjava</a>
        </div>
    </div>
</nav>

<main class="container">
    <h3 class="page-title"><?= $search ? "Rezultati za: " . htmlspecialchars($search) : "Preporučeni podcasti" ?></h3>
    
    <div class="podcast-grid">
        <?php
        $query = "SELECT * FROM podcast WHERE title LIKE ?";
        $stmt = $pdo->prepare($query);
        $stmt->execute(["%$search%"]);
        
        while ($row = $stmt->fetch()): 
            $img = !empty($row['cover_image_url']) ? $row['cover_image_url'] : 'img/default_cover.png';
        ?>
            <div class="podcast-card">
                <div class="card-img-wrapper">
                    <img src="<?= $img ?>" class="card-img">
                </div>
                <div class="card-body">
                    <h6 class="card-title"><?= $row['title'] ?></h6>
                    <a href="podcast_details.php?id=<?= $row['ID_podcast'] ?>" class="btn btn-primary btn-full">Pogledaj</a>
                </div>
            </div>
        <?php endwhile; ?>
    </div>
</main>

<script>
    document.getElementById('subsDropdownBtn').addEventListener('click', function(e) {
        e.stopPropagation();
        document.getElementById('subsDropdownMenu').classList.toggle('show');
    });

    // Zatvori dropdown ako korisnik klikne bilo gdje izvan njega
    document.addEventListener('click', function() {
        document.getElementById('subsDropdownMenu').classList.remove('show');
    });
</script>
</body>
</html>
