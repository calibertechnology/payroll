<?php
// based on https://code-boxx.com/simple-rest-api-php/ by W.S. Toh
include_once("config.inc");

class Employees {
  private $pdo = null;
  private $stmt = null;
  public $error = "";
  function __construct () {
    try {
      $this->pdo = new PDO(
        "mysql:host=".DB_HOST.";dbname=".DB_NAME.";charset=".DB_CHARSET, 
        DB_USER, DB_PASSWORD, [
          PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
          PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
      );
    } catch (Exception $ex) { exit($ex->getMessage()); }
  }

  function __destruct () {
    if ($this->stmt!==null) { $this->stmt = null; }
    if ($this->pdo!==null) { $this->pdo = null; }
  }

  function query ($sql, $data) {
    try {
      $this->stmt = $this->pdo->prepare($sql);
      $this->stmt->execute($data);
      return true;
    } catch (Exception $ex) {
      $this->error = $ex->getMessage();
      return false;
    }
  }

  function save ($employer, $last, $first, $address, $city, $state, $zip, $id=null) {
    $data = array(":employer" => $employer, ":last" => $last, ":first" => $first,
      ":address" => $address, ":city" => $city, ":state" => $state, ":zip" => $zip);
    if ($id===null) {
      $sql = "INSERT INTO employees (employer, last, first, address, city, state, zip) VALUES
        (:employer, :last, :first, :address, :city, :state, :zip)";
    } else {
      $data[':id'] = $id;
      $sql = "UPDATE employees SET employer=:employer, last=:last, first=:first,
        address=:address, city=:city, state=:state, zip=:zip WHERE id=:id";
    }
    return $this->query($sql, $data);
  }

  function del ($id) {
    return $this->query("DELETE FROM employees WHERE id=:id", [":id" => $id]);
  }
 
  function get ($id) {
    $this->query("SELECT * FROM employees WHERE id=:id", [":id" => $id]);
    return $this->stmt->fetch();
  }
 
  function all ($emp_id) {
    $this->query("SELECT * FROM employees WHERE employer=:emp_id", [":emp_id" => $emp_id]);
    $res = $this->stmt->fetchall();
    return $res;
  }
}

session_start();
$EMP = new Employees();

function respond ($status, $message, $more=null, $http=null) {
  if ($http !== null) { http_response_code($http); }
  exit(json_encode([
    "status" => $status,
    "message" => $message,
    "more" => $more
  ]));
}

if (isset($_POST["req"])) {
  switch ($_POST["req"]) {
  default:
  respond(false, "Invalid request", null, null, 400);
  break;

  case "save":
    $pass = $EMP->save(
      $_POST["employer"], $_POST["last"], $_POST["first"], $_POST["address"], $_POST["city"], $_POST["state"], $_POST["zip"],
      isset($_POST["id"]) ? $_POST["id"] : null
    );
    respond($pass, $pass?"OK":$EMP->error);
    break;

  case "del":
    $pass = $EMP->del($_POST["id"]);
    respond($pass, $pass?"OK":$EMP->error);
    break;

  case "get":
    respond(true, "OK", $EMP->get($_POST["id"]));
    break;

  case "all":
    respond(true, "OK", $EMP->all($_POST["emp_id"]));
    break;
  }
}
