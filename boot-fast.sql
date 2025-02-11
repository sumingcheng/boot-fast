create database boot_fast;
use boot_fast;

-- 用户表
CREATE TABLE
  users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    avatar_url VARCHAR(255) COMMENT '用户头像URL',
    user_status TINYINT DEFAULT 1 COMMENT '用户状态 1:启用 0:禁用',
    sort INT DEFAULT 0 COMMENT '排序号',
    remark VARCHAR(500) COMMENT '备注',
    operator_id BIGINT COMMENT '操作人ID',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除 1:已删除 0:未删除',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';

-- 角色表
CREATE TABLE
  roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(200) COMMENT '角色描述',
    role_status TINYINT DEFAULT 1 COMMENT '角色状态 1:启用 0:禁用',
    sort INT DEFAULT 0 COMMENT '排序号',
    remark VARCHAR(500) COMMENT '备注',
    operator_id BIGINT COMMENT '操作人ID',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除 1:已删除 0:未删除',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    INDEX idx_role_code (role_code)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '角色表';

-- 权限表
CREATE TABLE
  permissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    permission_type VARCHAR(50) COMMENT '权限类型 MENU:菜单 BUTTON:按钮 API:接口',
    description VARCHAR(200) COMMENT '权限描述',
    permission_status TINYINT DEFAULT 1 COMMENT '权限状态 1:启用 0:禁用',
    sort INT DEFAULT 0 COMMENT '排序号',
    remark VARCHAR(500) COMMENT '备注',
    operator_id BIGINT COMMENT '操作人ID',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除 1:已删除 0:未删除',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    INDEX idx_permission_code (permission_code)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '权限表';

-- 用户-角色关联表
CREATE TABLE
  user_roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    operator_id BIGINT COMMENT '操作人ID',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除 1:已删除 0:未删除',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_role (user_id, role_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户-角色关联表';

-- 角色-权限关联表
CREATE TABLE
  role_permissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    operator_id BIGINT COMMENT '操作人ID',
    is_deleted TINYINT DEFAULT 0 COMMENT '是否删除 1:已删除 0:未删除',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL COMMENT '删除时间',
    FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE,
    UNIQUE KEY unique_role_permission (role_id, permission_id),
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '角色-权限关联表';

-- 插入超级管理员角色
INSERT INTO
  roles (role_name, role_code, description)
VALUES
  ('超级管理员', 'ROLE_SUPER_ADMIN', '系统超级管理员，拥有所有权限');

-- 插入基础权限
INSERT INTO
  permissions (
    permission_name,
    permission_code,
    description,
    permission_type
  )
VALUES
  ('系统管理', 'SYSTEM:MANAGE', '系统管理权限', 'MENU'),
  ('用户管理', 'USER:MANAGE', '用户管理权限', 'MENU'),
  ('角色管理', 'ROLE:MANAGE', '角色管理权限', 'MENU'),
  ('权限管理', 'PERMISSION:MANAGE', '权限管理权限', 'MENU');

-- 插入root用户 (密码为加密后的 'root123')
INSERT INTO
  users (username, password, email, user_status)
VALUES
  (
    'root',
    '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUi',
    'root@example.com',
    1
  );

-- 为root用户分配超级管理员角色
INSERT INTO
  user_roles (user_id, role_id)
VALUES
  (1, 1);

-- 为超级管理员角色分配所有权限
INSERT INTO
  role_permissions (role_id, permission_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4);