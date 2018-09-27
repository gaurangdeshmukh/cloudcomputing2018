package com.example.user_login.Service;

import com.example.user_login.DAO.UserDAO;
import com.example.user_login.Entities.User;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Random;

@Service
public class UserService {
    @Autowired
    UserDAO userDao;

    public boolean authUser(String []userCredentials) {

        String username = userCredentials[0];

        String password = userCredentials[1];

        Optional<User> optionalUser = userDao.findById(username);

        try {
            User user = optionalUser.get();
            return checkHash(password, user.password);
        } catch (NoSuchElementException e) {
            return false;
        }
    }

    public boolean createUser(String []userCredentials){
        String username = userCredentials[0];

        String password = userCredentials[1];

        try {
            String hashedPassword = hash(password);

            User user = new User(username, hashedPassword);

            userDao.save(user);
            return true;
        }
        catch(Exception e){
            return false;
        }

    }

    public String hash(String password){
        if(password.isEmpty() || password == null){
            return null;
        }

        //Creating random salt with limit of 34
        Random rand = new Random();
        int log_rounds = rand.nextInt(20);

        return BCrypt.hashpw(password,BCrypt.gensalt(log_rounds));
    }

    public boolean checkHash(String password,String hash){
        if(password.isEmpty() || password == null){
            return false;
        }

        return BCrypt.checkpw(password,hash);
    }


}
