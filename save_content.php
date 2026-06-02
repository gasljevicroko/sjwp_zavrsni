
<?php
include 'config.php';
session_start();

if (!isset($_SESSION['user_id']) || $_SESSION['is_creator'] == 0) exit("Pristup odbijen");

$user_id = $_SESSION['user_id'];

// STVARANJE NOVOG PODCASTA
if (isset($_POST['new_podcast'])) {
    $title = $_POST['title'];
    $desc = $_POST['description'];
    $cat = $_POST['category_id'];
    $lang = $_POST['language_id'];

    // 1. Ubaci u tablicu 'podcast'
    $stmt = $pdo->prepare("INSERT INTO podcast (title, description, category_ID, language_ID) VALUES (?, ?, ?, ?)");
    $stmt->execute([$title, $desc, $cat, $lang]);
    
    $new_podcast_id = $pdo->lastInsertId();

    // 2. POVEŽI AUTORA (Jako važno!)
    $auth_stmt = $pdo->prepare("INSERT INTO podcast_author (podcast_ID, user_ID) VALUES (?, ?)");
    $auth_stmt->execute([$new_podcast_id, $user_id]);

    header("Location: creator_dashboard.php");
}

// DODAVANJE EPIZODE (uz provjeru autorstva)
if (isset($_POST['new_episode'])) {
    $podcast_id = $_POST['podcast_id'];
    
    // Sigurnosna provjera: Je li ovaj user stvarno autor ovog podcasta?
    $check = $pdo->prepare("SELECT * FROM podcast_author WHERE podcast_ID = ? AND user_ID = ?");
    $check->execute([$podcast_id, $user_id]);

    if ($check->rowCount() > 0) {
        $title = $_POST['title'];
        $num = $_POST['ep_number'];
        $desc = $_POST['description'];
        
        $stmt = $pdo->prepare("INSERT INTO episode (podcast_ID, title, episode_number, description) VALUES (?, ?, ?, ?)");
        $stmt->execute([$podcast_id, $title, $num, $desc]);
        
        header("Location: creator_dashboard.php");
    } else {
        exit("Nemate dozvolu za dodavanje epizoda ovom podcastu!");
    }
}
?>
