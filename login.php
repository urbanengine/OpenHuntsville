<?php
    //https://www.a2hosting.com/kb/developer-corner/postgresql/connect-to-postgresql-using-php
    $db_connection = pg_connect("host=ec2-54-197-253-253.compute-1.amazonaws.com dbname=d7hs14squarh6n user=hwsdhfrhptdtug password=1adc1e0c05fed45128033289a945351156ef1908c45c22453b1db055d0bc7bca");
    if (!$db_connection) {
        echo "An error occurred connecting to the database.\n";
        exit;
      }
    
    //TODO: Alter $email and $password to come from UI
    $email = 'memberlogintest@mailinator.com';
    $password = 'redblue12345';

    $result = pg_query($db_connection, "SELECT first_name, last_name, email, crypted_password FROM people WHERE email = '$email' and approved = true and is_elite = true"); 
    if (!$db_connection) {
        echo "An error occurred executing the query.\n";
        exit;
      }

    if (pg_num_rows($result) == 0) {
        echo "User not found!\n";
        exit;
    }
    elseif(pg_num_rows($result) > 1) {
        echo "More than one user found!\n";
        exit;
    }
    else {
        //https://stackoverflow.com/questions/4795385/how-do-you-use-bcrypt-for-hashing-passwords-in-php
        while ($row = pg_fetch_array($result)) {
            echo "$row[3]\n";
            echo  password_hash($password, PASSWORD_BCRYPT)."\n";
            if (password_verify($password, $row[3]))
                echo "Password is valid, user can login\n";
            else
                echo "Password is invalid, user cannot login\n";
        }
    }
?>