package com.sumingcheng.boot_fast.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Permission {
    private Long id;
    private String permissionName;
    private String permissionCode;
    private String permissionType;
    private String description;
    private Integer permissionStatus;
    private Integer sort;
    private String remark;
    private Long operatorId;
    private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
} 