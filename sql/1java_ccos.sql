SET NAMES utf8;
SET time_zone = '+08:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE IF NOT EXISTS `java-ccos` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `java-ccos`;

CREATE TABLE IF NOT EXISTS `hds_device_token` (
    `device_sn`                 varchar(50)   NOT NULL COMMENT '设备的sn号，这里是唯一的sn号',
    `device_ip`                 varchar(50)   NOT NULL COMMENT '设备IP，除了边缘设备，基本唯一',
    `token`               varchar(100)  DEFAULT NULL COMMENT 'token',
    `user_name`               varchar(100)  DEFAULT NULL COMMENT '登录用户',
    `user_pass`               varchar(100)  DEFAULT NULL COMMENT '用户密码',
    `login_time`          datetime(0)   NOT NULL COMMENT '登录时间',
    `server_token`               varchar(100)  DEFAULT NULL COMMENT '设备的服务token',
    `device_access_type`              tinyint(2)  NOT NULL DEFAULT 0 COMMENT '0 ip可达设备，1边缘端设备',
    `device_type` int NULL DEFAULT NULL  COMMENT '设备类型: 0 SE6, 1 SE5, 2 SG6-6, 3 SE7, 4 SE8, 5 SG10, 6 PCIE, 7 SG6-10, -1 UN_KNOW',
    PRIMARY KEY (`device_sn`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录token';

CREATE TABLE IF NOT EXISTS `hds_device_discovery` (
    `device_sn`         varchar(50)   NOT NULL COMMENT '设备的sn号',
    `device_ip`         varchar(50)   NOT NULL COMMENT '设备IP',
    `discovery_time`    datetime(0)   NOT NULL COMMENT '登录时间',
    `is_edge`           tinyint(2)    NOT NULL COMMENT '是否为边缘设备',
    `device_access_type`              tinyint(2)  NOT NULL DEFAULT 0 COMMENT '0 ip可达设备，1边缘端设备',
    `server_token`      varchar(100)  DEFAULT NULL COMMENT '服务token，用于和设备双向握手',
    `discovery_type`    varchar(20)   DEFAULT NULL COMMENT '发现方式:SCAN,REGISTER,EDGE,OTHER',
    PRIMARY KEY (`device_sn`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备发现记录';

CREATE TABLE IF NOT EXISTS `hds_device_heart` (
    `device_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备的sn号',
    `device_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备ip',
    `alive_period` int(11) NULL DEFAULT NULL COMMENT '保活周期',
    `reg_time` datetime NOT NULL COMMENT '注册时间',
    `date_time` datetime NOT NULL COMMENT '上报时间',
    `status` tinyint(11) NOT NULL COMMENT '设备状态: 0 在线 1 离线',
    `version` int(11) NOT NULL DEFAULT 1 COMMENT '乐观锁版本号',
    `collect_time` datetime NULL DEFAULT NULL COMMENT 'deviceInfo的收集时间',
    `agent_device_type` tinyint(11) NULL DEFAULT NULL COMMENT '设备类型:0 无卡；1 有卡无驱动；2 有卡有驱动；3 se5设备',
    `entity_type` tinyint(2) NOT NULL DEFAULT 0 COMMENT '0 物理设备，1虚拟设备',
    `net_info` json NULL COMMENT '网络状态,格式 {\"loss\":1.0,\"delay\"：\"9999\"}',
    `sub_devices` int(11) NOT NULL DEFAULT 0 COMMENT '子设备数量: 0 没有设备',
    `device_type` int(11) NULL DEFAULT NULL COMMENT '设备类型: 0 SE6, 1 SE5, 2 SG6-6, 3 SE7, 4 SE8, 5 SG10, 6 PCIE, 7 SG6-10, -1 UN_KNOW',
    PRIMARY KEY (`device_sn`) USING BTREE
    ) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备心跳保活' ROW_FORMAT = DYNAMIC;

CREATE TABLE IF NOT EXISTS `sub_device` (
    `sub_sn`           varchar(50)   NOT NULL COMMENT '子设备的sn号',
    `sub_ip`           varchar(50)   DEFAULT NULL COMMENT '子设备的内部ip',
    `sub_state`              tinyint(11)    NOT NULL COMMENT '子设备状态: 0 healthy；1 unhealthy；2 notLogin',
    `sub_type`           INT(11)   DEFAULT NULL COMMENT 'se6',
    `device_ip`                 varchar(50)   NOT NULL COMMENT '外键，设备ip',
    `device_sn`                 varchar(50)   NOT NULL COMMENT '设备的sn号',
    `number`               varchar(256)     NOT NULL   COMMENT '板卡序号',
    PRIMARY KEY (`sub_sn`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ssm管理的子设备';

CREATE TABLE IF NOT EXISTS `hds_operation_log` (
    `operation_id`                 varchar(50)   NOT NULL COMMENT '操作的ID',
    `operation_name`                 varchar(80)   DEFAULT NULL COMMENT '操作的对象名称',
    `operation_source_type`                 tinyint(11)   DEFAULT NULL COMMENT '操作资源类型',
    `operation_type`                 tinyint(11)   DEFAULT NULL COMMENT '操作类型',
    `parent_id`                 varchar(50)  DEFAULT NULL COMMENT '父ID',
    `device_ip`                 varchar(50)   DEFAULT NULL COMMENT '设备ip',
    `device_sn`                 varchar(50)    COMMENT '核心设备的sn号',
    `ctrl_sn`                 varchar(50)   COMMENT '控制设备的sn号',
    `request_method`    varchar(50)   DEFAULT NULL COMMENT '请求method',
    `request_url`       varchar(100)  DEFAULT NULL COMMENT '请求的url',
    `request_body`      JSON          DEFAULT NULL COMMENT '请求的body',
    `result_body`       JSON          DEFAULT NULL COMMENT '结果的body',
    `operate_result_msg`       JSON   DEFAULT NULL COMMENT '操作结果信息',
    `result_time`          datetime(0)   DEFAULT NULL COMMENT '结果上报时间',
    `status`              tinyint(11)    NOT NULL COMMENT '操作状态: 0 请求成功， 1 请求失败，2 结果处理成功, 3 结果处理失败',
    `notify_url`        varchar(100)  DEFAULT NULL COMMENT '异步通知的url',
    PRIMARY KEY (`operation_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作日志';


CREATE TABLE IF NOT EXISTS `hds_deploy_monitor` (
    `deploy_name`                 varchar(120)   NOT NULL COMMENT '应用名称',
    `device_ip`                 varchar(30)   NOT NULL COMMENT '设备ip，冗余字段',
    `device_sn`                 varchar(50)   NOT NULL COMMENT '控制设备sn号',
    `sub_sn`                 varchar(50)   DEFAULT NULL COMMENT '核心设备sn号',
    `status`                 varchar(50)   NOT NULL COMMENT 'running、exited、error、inactivation',
    `run_time`               varchar(45)  DEFAULT NULL COMMENT 'hh:mm:ss',
    `date_time`          datetime(0)   NOT NULL COMMENT '请求时间',
    `notify_url`         varchar(120)  DEFAULT NULL COMMENT '异步通知的url',
    `bind_chips`         JSON  DEFAULT NULL COMMENT '绑定芯片',
    `addr`         JSON  DEFAULT NULL COMMENT '地址',
    `labels`         JSON  DEFAULT NULL COMMENT '标签信息',
    `last_opt`              tinyint(10) DEFAULT NULL COMMENT '最近一次操作',
    `deploy_type`      smallint(5) DEFAULT NULL COMMENT '部署的应用类型：0：docker;1:裸包',
    `root_path` varchar(256)  DEFAULT NULL COMMENT '安装包目录',
    PRIMARY KEY (`deploy_name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应用监控';

CREATE TABLE IF NOT EXISTS `hds_subscribe` (
    `id`                   bigint(20)    NOT NULL AUTO_INCREMENT COMMENT 'id',
    `notification_url`                 varchar(120)   NOT NULL COMMENT '通知地址',
    `device_sn`                 varchar(50)   NOT NULL COMMENT '设备的sn号',
    `subscribe_type`                 json   NOT NULL COMMENT '[0,1,2]',
    `create_time`          datetime(0)   NOT NULL COMMENT '创建时间',
    `modify_time`          datetime(0)   NOT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `UK_device_notify`(`device_sn`, `notification_url`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='信息订阅表';

CREATE TABLE IF NOT EXISTS `hds_device_vm` (
    `vm_id`             bigint(20)    NOT NULL AUTO_INCREMENT COMMENT '虚拟机ID',
    `device_sn`         varchar(50)   NOT NULL COMMENT '宿主机的sn号',
    `vm_name`           varchar(50)   NOT NULL COMMENT '虚拟机名称',
    `vm_type`           INT(11)       NOT NULL DEFAULT 1 COMMENT '虚拟机类型，对应底层不同的脚本和镜像',
    `ip`                varchar(50)   NOT NULL COMMENT 'vm的IP',
    `create_time`       datetime(0)   NOT NULL COMMENT '请求创建vm的时间',
    `complete_time`     datetime(0)   DEFAULT NULL COMMENT '创建完成的时间',
    `operate_status`    tinyint(2)    NOT NULL COMMENT '虚拟机操作状态：0创建中 1创建成功 2创建失败 3删除中 4删除失败 5重置中 6重置删除成功 7重置删除失败 8重置创建中 9 重置失败',
    `status`            tinyint(2)    DEFAULT NULL COMMENT 'vm实时状态：0 running 、1 shutdown、2 not exist',
    `params`            json          DEFAULT NULL COMMENT 'vm创建请求body',
    `build_type`        int(11)       NOT NULL DEFAULT 0 COMMENT '0 vm虚拟机、1 docker',
    `ssh_port`          int(11)       DEFAULT NULL COMMENT 'docker方式下的ssh对外端口',
    `update_time`       datetime(0)   DEFAULT NULL COMMENT '更新时间',
    `vnc_port`          int(11)       DEFAULT NULL COMMENT 'vnc协议端口',
    PRIMARY KEY (`vm_id`),
    UNIQUE INDEX `index2` (`device_sn`, `vm_name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='虚拟机管理';

CREATE TABLE IF NOT EXISTS `open_device`  (
    `device_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `parent_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父设备的sn号',
    `device_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备名称',
    `open_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0.0.0.0' COMMENT '设备ip',
    `ssh_user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SSH系统用户名',
    `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码，机器登录',
    `sn` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备sn号，必须唯一',
    `create_time` datetime NULL DEFAULT NULL COMMENT '开放时间',
    `cpu` int(11) NOT NULL DEFAULT 1 COMMENT '单位 核',
    `memory` int(11) NOT NULL DEFAULT 1 COMMENT '内存，单位 GB',
    `disk` int(11) NOT NULL DEFAULT 1 COMMENT '磁盘，单位 GB',
    `scards` int(11) NULL DEFAULT NULL COMMENT '单位 张',
    `scard_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求时指定',
    `operating_system` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备操作系统，请求时参数',
    `sdk_version` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sdk驱动版本，请求时参数',
    `notify_url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回调通知地址，请求时参数',
    `on_line` tinyint(2) NULL DEFAULT NULL COMMENT '0下线 1上线',
    `vm_type` int(11) NULL DEFAULT NULL COMMENT '虚拟机类型，对应底层不同的脚本和镜像',
    `build_type` int(11) NOT NULL DEFAULT 0 COMMENT '0 vm虚拟机、1 docker',
    `ssh_port` int(11) NULL DEFAULT NULL COMMENT 'docker方式下的ssh对外端口',
    `virtualization` tinyint(2) NOT NULL DEFAULT 0 COMMENT '0不能docker化 1 可以docker化',
    `occupy_type` tinyint(2) NULL DEFAULT NULL COMMENT '芯片占用类型，0独占模式 1 共享模式',
    `vnc_port` smallint(5) UNSIGNED NULL DEFAULT NULL COMMENT 'VNC端口',
    `vnc_user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'VNC系统用户名',
    PRIMARY KEY (`device_id`) USING BTREE,
    UNIQUE INDEX `sn_UNIQUE`(`sn` ASC) USING BTREE,
    UNIQUE INDEX `open_ip_port_UNIQUE`(`open_ip` ASC, `ssh_port` ASC) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开放设备';


CREATE TABLE IF NOT EXISTS `open_ips`  (
    `open_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '开放ip地址',
    `status` int NOT NULL DEFAULT 0 COMMENT '状态0 空闲 1 被占用',
    `description` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip描述',
    `device_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '绑定设备sn,设备独占资源',
    PRIMARY KEY (`open_ip`) USING BTREE
    ) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '开放ip池' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `open_ports`  (
                                             `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                             `device_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备SN',
    `ssh_port` smallint UNSIGNED NOT NULL COMMENT '开放端口',
    `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态 0:空闲；1:占用',
    `description` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_device_port`(`device_sn` ASC, `ssh_port` ASC) USING BTREE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '开放端口池' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `vm_chip` (
    `id`                bigint(20)    NOT NULL AUTO_INCREMENT COMMENT '主键',
    `device_sn`         varchar(50)   NOT NULL COMMENT '设备的sn号',
    `chip_sn`           varchar(50)   NOT NULL COMMENT '芯片slot；05:00:0、05:00:1',
    `board_sn`          varchar(50)   NOT NULL COMMENT '板卡的sn号；01、05、06',
    `scard_type`        varchar(50)   DEFAULT NULL COMMENT '板卡类型，基本信息里可以获取',
    `vm_id`             bigint(20)    DEFAULT NULL COMMENT '虚拟机ID',
    `vm_name`           varchar(50)   DEFAULT NULL COMMENT '虚拟机名称',
    `vm_type`           INT(11)       DEFAULT NULL COMMENT '虚拟机类型，对应底层不同的脚本和镜像',
    `share_num`         INT(11)       DEFAULT NULL COMMENT '芯片现有占用vm数目',
    `share_limit`       INT(11)       NOT NULL DEFAULT 1 COMMENT '芯片被共享使用vm数量上限，默认是1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `chip_UNIQUE` (`device_sn`,`chip_sn`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='虚拟机绑定芯片';

CREATE TABLE IF NOT EXISTS `vm_chip_share` (
    `id`                bigint(20)    NOT NULL AUTO_INCREMENT COMMENT '主键',
    `vm_chip_id`        bigint(20)    NOT NULL  COMMENT '芯片ID',
    `create_time`       datetime(0)   NOT NULL COMMENT '请求创建vm的时间',
    `vm_id`             bigint(20)    DEFAULT NULL COMMENT '虚拟机ID',
    `vm_name`           varchar(50)   DEFAULT NULL COMMENT '虚拟机名称',
    `vm_type`           INT(11)       DEFAULT NULL COMMENT '虚拟机类型，对应底层不同的脚本和镜像',
    PRIMARY KEY (`id`),
    UNIQUE KEY `chip_UNIQUE` (`vm_chip_id`,`vm_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vm绑定芯片共享模式扩展表';

CREATE TABLE IF NOT EXISTS `open_device_volume`  (
                                                     `id` bigint NOT NULL AUTO_INCREMENT,
                                                     `storage_size` int NOT NULL COMMENT '请求的磁盘大小，单位GB',
                                                     `mount_path` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '真实挂载目录',
    `vm_id` bigint NULL DEFAULT NULL COMMENT 'kvm或者虚拟化容器的id，open_device的device_id',
    `image_id` bigint NULL DEFAULT NULL COMMENT '磁盘镜像id',
    `src_volume` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'docker容器内部目录映射',
    `device_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物理设备的sn号，冗余字段',
    `map_type` tinyint NULL DEFAULT NULL COMMENT '0 直接rbd挂载（物理机上map） 、1 网盘挂载方式（KVM）、2共享存储挂载（暂时不用）',
    `dev_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '挂载的dev名称，比如/dev/rbd0',
    PRIMARY KEY (`id`) USING BTREE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备的扩展磁盘、目录；' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `open_storage_image`  (
                                                     `id` bigint NOT NULL AUTO_INCREMENT,
                                                     `pool_id` bigint NOT NULL COMMENT '存储池ID，外键',
                                                     `pool_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '所属存储名称，冗余字段',
    `image_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据盘镜像名称',
    `image_capacity` int NOT NULL DEFAULT 1 COMMENT '存储镜像容量；磁盘大小 单位GB；必须要有值',
    `device_sn` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备物理心跳设备的sn；',
    `vm_id` bigint NULL DEFAULT NULL COMMENT '虚拟机的id',
    `map_type` tinyint NULL DEFAULT NULL COMMENT '0 直接rbd挂载（物理机上map） 、1 网盘挂载方式（KVM）、2共享存储挂载（暂时不用）',
    `dev_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '挂载的dev名称，比如/dev/rbd0',
    `mount_path` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '挂载目录',
    `status` tinyint NULL DEFAULT NULL COMMENT '状态：0 新建（不可用）、1 空闲（初始化成功） 、2 初始化失败（不可用）、3占用（已经map）、4挂载进行中、5挂载失败',
    `create_time` datetime NOT NULL,
    `modify_time` datetime NULL DEFAULT NULL,
    `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
    `src_volume` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'docker容器内部目录映射',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `poolkey_idx`(`pool_id` ASC) USING BTREE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '存储镜像，数据盘' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `open_storage_pool`  (
                                                    `id` bigint NOT NULL AUTO_INCREMENT,
                                                    `pool_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '存储池名称，ceph里面pool，不要使用特殊字符和中文',
    `pool_max_capacity` int NOT NULL DEFAULT 0 COMMENT '存储池容量上限，单位GB；为0时不做限制',
    `status` tinyint NOT NULL DEFAULT 0 COMMENT '存储池状态：0新建（不可用；可编辑删除） 、1 初始化成功（可用）、2初始化失败（不可用）',
    `create_time` datetime NOT NULL COMMENT '创建时间',
    `max_objects` int NOT NULL DEFAULT 999 COMMENT '最大对象限制',
    `pg_num` int NOT NULL DEFAULT 128 COMMENT '归置组数量;若少于5个OSD， 设置pg_num为128，5~10个OSD，设置pg_num为512，10~50个OSD，设置pg_num为4096\r',
    `pgp_num` int NOT NULL DEFAULT 128 COMMENT '计算数据归置时使用的有效归置组数量;若少于5个OSD， 设置pg_num为128，5~10个OSD，设置pg_num为512，10~50个OSD，设置pg_num为4096\r',
    `pool_size` int NOT NULL DEFAULT 2 COMMENT '存储池中对象的副本数，默认为2',
    `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '备注',
    `modify_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '存储资源池;存储按照pool进行隔离，可以按照作用 进行划分' ROW_FORMAT = Dynamic;


-- ----------------------------
-- 下面是新增或修改字段相关SQL
-- ----------------------------

DROP PROCEDURE IF EXISTS modify_columns;
DELIMITER //
CREATE PROCEDURE modify_columns()
BEGIN

-- ---- ----------------------------
-- hds_device_discovery新增字段
-- ----------------------------
SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_discovery' AND COLUMN_NAME = 'discovery_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_discovery ADD `discovery_type` varchar(20)  DEFAULT NULL COMMENT '发现方式:SCAN,REGISTER,EDGE,OTHER';
END IF;

-- ----------------------------
-- hds_device_heart新增字段
-- ----------------------------
SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_heart' AND COLUMN_NAME = 'alive_period';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_heart ADD `alive_period` int(11) DEFAULT NULL COMMENT '保活周期';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_heart' AND COLUMN_NAME = 'agent_device_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_heart ADD `agent_device_type` tinyint(11) DEFAULT NULL COMMENT '设备类型:0 无卡；1 有卡无驱动；2 有卡有驱动；3 se5设备';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_heart' AND COLUMN_NAME = 'entity_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_heart ADD `entity_type` tinyint(2) NOT NULL DEFAULT 0 COMMENT '0 物理设备，1虚拟设备';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_heart' AND COLUMN_NAME = 'net_info';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_heart ADD `net_info` json NULL COMMENT '网络状态,格式 {\"loss\":1.0,\"delay\"：\"9999\"}';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_heart' AND COLUMN_NAME = 'device_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_heart ADD `device_type` int(11) NULL DEFAULT NULL COMMENT '设备类型: 0 SE6, 1 SE5, 2 SG6-6, 3 SE7, 4 SE8, 5 SG10, 6 PCIE, 7 SG6-10, -1 UN_KNOW';
END IF;


-- ----------------------------
-- hds_device_token新增字段
-- ----------------------------
SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_device_token' AND COLUMN_NAME = 'device_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_device_token ADD `device_type` int(11) NULL DEFAULT NULL COMMENT '设备类型: 0 SE6, 1 SE5, 2 SG6-6, 3 SE7, 4 SE8, 5 SG10, 6 PCIE, 7 SG6-10, -1 UN_KNOW';
END IF;

-- ----------------------------
-- hds_operation_log新增字段
-- ----------------------------
SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_operation_log' AND COLUMN_NAME = 'request_method';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_operation_log ADD `request_method` varchar(50) DEFAULT NULL COMMENT '请求method';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_operation_log' AND COLUMN_NAME = 'request_url';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_operation_log ADD `request_url` varchar(100)  DEFAULT NULL COMMENT '请求的url';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_operation_log' AND COLUMN_NAME = 'request_body';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_operation_log ADD `request_body` JSON DEFAULT NULL COMMENT '请求的body';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_operation_log' AND COLUMN_NAME = 'result_body';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_operation_log ADD `result_body` JSON DEFAULT NULL COMMENT '结果的body';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_operation_log' AND COLUMN_NAME = 'notify_url';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_operation_log ADD `notify_url` varchar(100)  DEFAULT NULL COMMENT '异步通知的url';
END IF;

-- ----------------------------
-- sub_device新增字段
-- ----------------------------
SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'sub_device' AND COLUMN_NAME = 'number';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.sub_device ADD `number` varchar(256) NOT NULL COMMENT '板卡序号';
END IF;


SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_deploy_monitor' AND COLUMN_NAME = 'deploy_type';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_deploy_monitor ADD `deploy_type` smallint(5) UNSIGNED DEFAULT NULL COMMENT '部署的应用类型：0：docker;1:裸包';
END IF;


SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_deploy_monitor' AND COLUMN_NAME = 'status';
IF(@count = 1) THEN
ALTER TABLE `java-ccos`.hds_deploy_monitor modify `status` smallint(5) DEFAULT NULL COMMENT '应用状态 0：运行中；1：已退出；2：失败；3：操作中；4：失效；5：已创建；6：删除中；7：重启中；8：创建中；9：已启动';
END IF;

SELECT count(*) INTO @count FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'java-ccos' AND TABLE_NAME = 'hds_deploy_monitor' AND COLUMN_NAME = 'root_path';
IF(@count = 0) THEN
ALTER TABLE `java-ccos`.hds_deploy_monitor ADD `root_path` varchar(256) DEFAULT NULL COMMENT '安装包目录';
END IF;

END;

//
DELIMITER ;
call modify_columns;
DROP PROCEDURE IF EXISTS modify_columns;