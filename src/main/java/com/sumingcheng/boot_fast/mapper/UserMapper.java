package com.sumingcheng.boot_fast.mapper;

import com.sumingcheng.boot_fast.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

@Mapper
public interface UserMapper {
    User findByUsername(String username);
    
    List<User> findAll();
    
    int insert(User user);
    
    int update(User user);
    
    int deleteById(Long id);
    
    Set<String> findUserPermissions(@Param("userId") Long userId);
    
    Set<String> findUserRoles(@Param("userId") Long userId);
} 