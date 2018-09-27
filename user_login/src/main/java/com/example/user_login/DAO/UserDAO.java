package com.example.user_login.DAO;

import com.example.user_login.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserDAO extends JpaRepository<User,String> {

}
