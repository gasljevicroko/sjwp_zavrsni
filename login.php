

<?php
include 'config.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['register'])) {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password']; // Napomena: U produkciji obavezno password_hash()
    $is_creator = isset($_POST['is_creator']) ? 1 : 0;

    $stmt = $pdo->prepare("INSERT INTO user (name, email, password, is_creator) VALUES (?, ?, ?, ?)");
    $stmt->execute([$name, $email, $password, $is_creator]);
    echo "<script>alert('Registracija uspješna! Prijavite se.');</script>";
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['login'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $pdo->prepare("SELECT * FROM user WHERE email = ? AND password = ?");
    $stmt->execute([$email, $password]);
    $user = $stmt->fetch();

    if ($user) {
        $_SESSION['user_id'] = $user['ID_user'];
        $_SESSION['user_name'] = $user['name'];
        $_SESSION['is_creator'] = $user['is_creator'];
        header("Location: index.php");
        exit();
    } else {
        echo "<script>alert('Pogrešni podaci!');</script>";
    }
}
?>

<!DOCTYPE html>
<html lang="hr">
<head>
    <meta charset="UTF-8">
    <title>PodWave - Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="centered-container">

    <div class="auth-card">
        <h2 class="auth-logo">PodWave</h2>
        
        <div class="tab-nav">
            <button class="tab-btn active" onclick="switchTab('login-tab', this)">Prijava</button>
            <button class="tab-btn" onclick="switchTab('reg-tab', this)">Registracija</button>
        </div>

        <div class="tab-content">
            <div id="login-tab" class="tab-pane active">
                <form method="POST">
                    <input type="email" name="email" class="form-input mb-3" placeholder="Email" required>
                    <input type="password" name="password" class="form-input mb-3" placeholder="Lozinka" required>
                    <button type="submit" name="login" class="btn btn-primary btn-full">Prijavi se</button>
                </form>
            </div>

            <div id="reg-tab" class="tab-pane">
                <form method="POST">
                    <input type="text" name="name" class="form-input mb-3" placeholder="Ime i prezime" required>
                    <input type="email" name="email" class="form-input mb-3" placeholder="Email" required>
                    <input type="password" name="password" class="form-input mb-3" placeholder="Lozinka" required>
                    
                    <div class="form-checkbox-group mb-3">
                        <input type="checkbox" name="is_creator" id="creatorCheck" class="custom-checkbox">
                        <label for="creatorCheck" class="checkbox-label">Registriraj se kao Kreator</label>
                    </div>
                    
                    <button type="submit" name="register" class="btn btn-success btn-full">Registriraj se</button>
                </form>
            </div>
        </div>
    </div>

<script>
    function switchTab(tabId, button) {
        // Sakrij sve tabove
        document.querySelectorAll('.tab-pane').forEach(tab => tab.classList.remove('active'));
        // Makni 'active' klasu sa svih gumbova
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        
        // Prikaži kliknuti tab i aktiviraj gumb
        document.getElementById(tabId).classList.add('active');
        button.classList.add('active');
    }
</script>
</body>
</html>
