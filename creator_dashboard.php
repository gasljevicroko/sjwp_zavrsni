
<?php
include 'config.php';
session_start();

// Provjera: Samo kreatori smiju ovdje
if (!isset($_SESSION['user_id']) || $_SESSION['is_creator'] == 0) {
    header("Location: index.php");
    exit();
}

$user_id = $_SESSION['user_id'];

// --- LOGIKA ZA BRISANJE EPIZODE ---
if (isset($_GET['delete_episode'])) {
    $del_id = $_GET['delete_episode'];
    
    // Sigurnosna provjera vlasništva
    $check_auth = $pdo->prepare("
        SELECT e.ID_episode FROM episode e
        JOIN podcast_author pa ON e.podcast_ID = pa.podcast_ID
        WHERE e.ID_episode = ? AND pa.user_ID = ?
    ");
    $check_auth->execute([$del_id, $user_id]);
    
    if ($check_auth->rowCount() > 0) {
        $del_stmt = $pdo->prepare("DELETE FROM episode WHERE ID_episode = ?");
        $del_stmt->execute([$del_id]);
        header("Location: creator_dashboard.php?msg=deleted");
        exit();
    }
}

// --- LOGIKA ZA DODAVANJE EPIZODE IZ MODALA ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['submit_episode'])) {
    $podcast_id = $_POST['podcast_id'];
    $title = $_POST['title'];
    $description = $_POST['description'];
    $episode_number = $_POST['episode_number'];

    $ins_stmt = $pdo->prepare("INSERT INTO episode (podcast_ID, title, description, episode_number) VALUES (?, ?, ?, ?)");
    $ins_stmt->execute([$podcast_id, $title, $description, $episode_number]);

    header("Location: creator_dashboard.php?msg=episode_added");
    exit();
}

// 1. Statistika
$stats_stmt = $pdo->prepare("
    SELECT COUNT(DISTINCT p.ID_podcast) as total_podcasts, COUNT(e.ID_episode) as total_episodes
    FROM podcast p
    JOIN podcast_author pa ON p.ID_podcast = pa.podcast_ID
    LEFT JOIN episode e ON p.ID_podcast = e.podcast_ID
    WHERE pa.user_ID = ?
");
$stats_stmt->execute([$user_id]);
$stats = $stats_stmt->fetch();
?>

<!DOCTYPE html>
<html lang="hr">
<head>
    <meta charset="UTF-8">
    <title>Creator Dashboard - PodWave</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="navbar">
    <div class="container nav-container">
        <a class="navbar-brand" href="index.php">PODWAVE</a>
        <span class="nav-text">Creator: <?= htmlspecialchars($_SESSION['user_name']) ?></span>
    </div>
</nav>

<main class="container">
    <div class="stats-row">
        <div class="stat-card card-purple">
            <h3>Moji Podcasti: <?= $stats['total_podcasts'] ?></h3>
        </div>
        <div class="stat-card card-cyan">
            <h3>Ukupno Epizoda: <?= $stats['total_episodes'] ?></h3>
        </div>
    </div>

    <div class="section-header">
        <h4>Upravljanje Sadržajem</h4>
        <button class="btn btn-primary" id="openModalBtn">+ Novi Podcast</button>
    </div>

    <div class="table-responsive">
        <table class="custom-table">
            <thead>
                <tr>
                    <th>Podcast</th>
                    <th>Kategorija / jezik</th>
                    <th>Broj Epizoda</th>
                    <th>Akcije</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $stmt = $pdo->prepare("
                    SELECT p.*, c.name as cat_name, l.name as lang_name,
                    (SELECT COUNT(*) FROM episode WHERE podcast_ID = p.ID_podcast) as ep_count
                    FROM podcast p
                    JOIN podcast_author pa ON p.ID_podcast = pa.podcast_ID
                    JOIN category c ON p.category_ID = c.category_ID
                    JOIN language l ON p.language_ID = l.language_ID
                    WHERE pa.user_ID = ?
                ");
                $stmt->execute([$user_id]);

                while ($p = $stmt->fetch()): 
                    $ep_stmt = $pdo->prepare("SELECT ID_episode, title, episode_number FROM episode WHERE podcast_ID = ? ORDER BY episode_number ASC");
                    $ep_stmt->execute([$p['ID_podcast']]);
                    $podcast_episodes = $ep_stmt->fetchAll(PDO::FETCH_ASSOC);
                ?>
                <tr>
                    <td><strong><?= htmlspecialchars($p['title']) ?></strong></td>
                    <td><?= htmlspecialchars($p['cat_name']) ?> (<?= htmlspecialchars($p['lang_name']) ?>)</td>
                    <td><?= $p['ep_count'] ?> epizoda</td>
                    <td>
                        <div class="table-actions">
                            <button type="button" class="btn btn-success btn-sm add-episode-btn"
                                    data-id="<?= $p['ID_podcast'] ?>"
                                    data-title="<?= htmlspecialchars($p['title']) ?>">
                                Dodaj Epizodu
                            </button>
                            
                            <button type="button" class="btn btn-outline btn-sm edit-podcast-btn"
                                    data-id="<?= $p['ID_podcast'] ?>"
                                    data-title="<?= htmlspecialchars($p['title']) ?>"
                                    data-desc="<?= htmlspecialchars($p['description']) ?>"
                                    data-cat="<?= $p['category_ID'] ?>"
                                    data-lang="<?= $p['language_ID'] ?>"
                                    data-episodes='<?= json_encode($podcast_episodes, JSON_HEX_APOS | JSON_HEX_QUOT) ?>'>
                                Uredi
                            </button>
                        </div>
                    </td>
                </tr>
                <?php endwhile; ?>
            </tbody>
        </table>
    </div>
</main>

<dialog id="addPodcastModal" class="custom-modal">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title">Stvori Novi Podcast</h5>
            <button type="button" class="close-modal-btn" id="closeModalBtn">&times;</button>
        </div>
        <form action="save_content.php" method="POST">
            <div class="modal-body">
                <input type="text" name="title" class="form-input mb-3" placeholder="Naslov podcasta" required>
                <textarea name="description" class="form-input mb-3" placeholder="Opis" rows="3"></textarea>
                
                <div class="form-group mb-3">
                    <label class="form-label">Kategorija:</label>
                    <select name="category_id" class="form-select">
                        <?php 
                        $cats = $pdo->query("SELECT * FROM category")->fetchAll();
                        foreach($cats as $c) echo "<option value='{$c['category_ID']}'>" . htmlspecialchars($c['name']) . "</option>";
                        ?>
                    </select>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label">Jezik:</label>
                    <select name="language_id" class="form-select">
                        <?php 
                        $langs = $pdo->query("SELECT * FROM language")->fetchAll();
                        foreach($langs as $l) echo "<option value='{$l['language_ID']}'>" . htmlspecialchars($l['name']) . "</option>";
                        ?>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" name="new_podcast" class="btn btn-primary btn-full">Spremi Podcast</button>
            </div>
        </form>
    </div>
</dialog>

<dialog id="editPodcastModal" class="custom-modal">
    <div class="modal-content" style="max-width: 650px;">
        <div class="modal-header">
            <h5 class="modal-title">Uredi Podcast & Epizode</h5>
            <button type="button" class="close-modal-btn" id="closeEditModalBtn">&times;</button>
        </div>
        <form action="save_content.php" method="POST">
            <input type="hidden" name="podcast_id" id="edit_podcast_id">
            
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Naslov podcasta:</label>
                    <input type="text" name="title" id="edit_title" class="form-input" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Opis:</label>
                    <textarea name="description" id="edit_description" class="form-input" rows="2" required></textarea>
                </div>
                
                <div style="display: flex; gap: 15px;" class="mb-3">
                    <div class="form-group" style="flex: 1;">
                        <label class="form-label">Kategorija:</label>
                        <select name="category_id" id="edit_category_id" class="form-select">
                            <?php foreach($cats as $c) echo "<option value='{$c['category_ID']}'>" . htmlspecialchars($c['name']) . "</option>"; ?>
                        </select>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label class="form-label">Jezik:</label>
                        <select name="language_id" id="edit_language_id" class="form-select">
                            <?php foreach($langs as $l) echo "<option value='{$l['language_ID']}'>" . htmlspecialchars($l['name']) . "</option>"; ?>
                        </select>
                    </div>
                </div>

                <button type="submit" name="update_podcast" class="btn btn-primary btn-sm mb-3">Spremi izmjene podcasta</button>
            </div>
        </form>

        <div class="modal-body" style="border-top: 1px solid #333333; background-color: #171717;">
            <h6 class="mb-3" style="font-weight: 600; color: #007bff;">Upravljanje Epizodama</h6>
            <div id="no_episodes_msg" class="text-muted small mb-2" style="display: none;">Ovaj podcast još nema dodanih epizoda.</div>
            
            <div class="table-responsive" id="episodes_table_wrapper" style="max-height: 200px; overflow-y: auto;">
                <table class="custom-table" style="font-size: 0.85rem;">
                    <thead>
                        <tr>
                            <th>Br.</th>
                            <th>Naziv Epizode</th>
                            <th style="text-align: right;">Akcija</th>
                        </tr>
                    </thead>
                    <tbody id="modal_episodes_body"></tbody>
                </table>
            </div>
        </div>
    </div>
</dialog>

<dialog id="addEpisodeModal" class="custom-modal">
    <div class="modal-content">
        <div class="modal-header">
            <div>
                <h5 class="modal-title">Nova Epizoda</h5>
                <span id="add_ep_podcast_title" style="color: #aaaaaa; font-size: 0.8rem;"></span>
            </div>
            <button type="button" class="close-modal-btn" id="closeEpModalBtn">&times;</button>
        </div>
        <form action="creator_dashboard.php" method="POST">
            <input type="hidden" name="podcast_id" id="add_ep_podcast_id">
            
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Broj epizode:</label>
                    <input type="number" name="episode_number" class="form-input" placeholder="Npr. 1" min="1" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Naslov epizode:</label>
                    <input type="text" name="title" class="form-input" placeholder="Naslov epizode..." required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Opis epizode:</label>
                    <textarea name="description" class="form-input" rows="3" placeholder="Kratki sadržaj..." required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" name="submit_episode" class="btn btn-success btn-full">Objavi epizodu</button>
            </div>
        </form>
    </div>
</dialog>

<script>
    // --- 1. MODAL: NOVI PODCAST ---
    const addModal = document.getElementById('addPodcastModal');
    const openBtn = document.getElementById('openModalBtn');
    const closeModalBtn = document.getElementById('closeModalBtn');

    openBtn.addEventListener('click', () => addModal.showModal());
    closeModalBtn.addEventListener('click', () => addModal.close());
    addModal.addEventListener('click', (e) => { if (e.target === addModal) addModal.close(); });


    // --- 2. MODAL: UREDI PODCAST & EPIZODE ---
    const editModal = document.getElementById('editPodcastModal');
    const closeEditModalBtn = document.getElementById('closeEditModalBtn');
    const modalEpisodesBody = document.getElementById('modal_episodes_body');
    const noEpisodesMsg = document.getElementById('no_episodes_msg');
    const episodesTableWrapper = document.getElementById('episodes_table_wrapper');

    document.querySelectorAll('.edit-podcast-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.getElementById('edit_podcast_id').value = this.getAttribute('data-id');
            document.getElementById('edit_title').value = this.getAttribute('data-title');
            document.getElementById('edit_description').value = this.getAttribute('data-desc');
            document.getElementById('edit_category_id').value = this.getAttribute('data-cat');
            document.getElementById('edit_language_id').value = this.getAttribute('data-lang');

            modalEpisodesBody.innerHTML = '';
            const episodes = JSON.parse(this.getAttribute('data-episodes'));

            if (episodes.length === 0) {
                noEpisodesMsg.style.display = 'block';
                episodesTableWrapper.style.display = 'none';
            } else {
                noEpisodesMsg.style.display = 'none';
                episodesTableWrapper.style.display = 'block';

                episodes.forEach(ep => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>${ep.episode_number}</td>
                        <td><strong>${escapeHtml(ep.title)}</strong></td>
                        <td style="text-align: right;">
                            <a href="creator_dashboard.php?delete_episode=${ep.ID_episode}" 
                               class="btn btn-sm btn-outline" 
                               style="color: #ff4d4d; border-color: #ff4d4d; padding: 2px 8px;"
                               onclick="return confirm('Sigurno želite obrisati ovu epizodu?')">
                               Obriši
                            </a>
                        </td>
                    `;
                    modalEpisodesBody.appendChild(tr);
                });
            }
            editModal.showModal();
        });
    });

    closeEditModalBtn.addEventListener('click', () => editModal.close());
    editModal.addEventListener('click', (e) => { if (e.target === editModal) editModal.close(); });


    // --- 3. MODAL: DODAJ EPIZODU ---
    const epModal = document.getElementById('addEpisodeModal');
    const closeEpModalBtn = document.getElementById('closeEpModalBtn');

    document.querySelectorAll('.add-episode-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const podcastId = this.getAttribute('data-id');
            const podcastTitle = this.getAttribute('data-title');

            // Postavi ID u skriveno polje forme i napiši ime podcasta u zaglavlje
            document.getElementById('add_ep_podcast_id').value = podcastId;
            document.getElementById('add_ep_podcast_title').textContent = "Za podcast: " + podcastTitle;

            epModal.showModal();
        });
    });

    closeEpModalBtn.addEventListener('click', () => epModal.close());
    epModal.addEventListener('click', (e) => { if (e.target === epModal) epModal.close(); });


    // Pomoćna funkcija
    function escapeHtml(text) {
        return text
            .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;").replace(/'/g, "&#039;");
    }
</script>
</body>
</html>
