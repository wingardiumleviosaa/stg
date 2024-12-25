    /*
    * Licensed to the Apache Software Foundation (ASF) under one or more
    * contributor license agreements.  See the NOTICE file distributed with
    * this work for additional information regarding copyright ownership.
    * The ASF licenses this file to You under the Apache License, Version 2.0
    * (the "License"); you may not use this file except in compliance with
    * the License.  You may obtain a copy of the License at
    *
    *    http://www.apache.org/licenses/LICENSE-2.0
    *
    * Unless required by applicable law or agreed to in writing, software
    * distributed under the License is distributed on an "AS IS" BASIS,
    * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    * See the License for the specific language governing permissions and
    * limitations under the License.
    */
    create database if not exists `streampark` character set utf8mb4 collate utf8mb4_general_ci;

    use streampark;

    set
        names utf8mb4;

    set
        foreign_key_checks = 0;

    -- ----------------------------
    -- table structure for t_app_backup
    -- ----------------------------
    drop table if exists `t_app_backup`;

    create table `t_app_backup` (
        `id` bigint not null auto_increment,
        `app_id` bigint default null,
        `sql_id` bigint default null,
        `config_id` bigint default null,
        `version` int default null,
        `path` varchar(128) collate utf8mb4_general_ci default null,
        `description` varchar(255) collate utf8mb4_general_ci default null,
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_flink_app
    -- ----------------------------
    drop table if exists `t_flink_app`;

    create table `t_flink_app` (
        `id` bigint not null auto_increment,
        `team_id` bigint not null,
        `job_type` tinyint default null,
        `execution_mode` tinyint default null,
        `resource_from` tinyint default null,
        `project_id` bigint default null,
        `job_name` varchar(255) collate utf8mb4_general_ci default null,
        `module` varchar(255) collate utf8mb4_general_ci default null,
        `jar` varchar(255) collate utf8mb4_general_ci default null,
        `jar_check_sum` bigint default null,
        `main_class` varchar(255) collate utf8mb4_general_ci default null,
        `dependency` text collate utf8mb4_general_ci default null,
        `args` longtext collate utf8mb4_general_ci,
        `options` longtext collate utf8mb4_general_ci,
        `hot_params` text collate utf8mb4_general_ci,
        `user_id` bigint default null,
        `app_type` tinyint default null,
        `duration` bigint default null,
        `job_id` varchar(64) collate utf8mb4_general_ci default null,
        `job_manager_url` varchar(255) collate utf8mb4_general_ci default null,
        `version_id` bigint default null,
        `cluster_id` varchar(45) collate utf8mb4_general_ci default null,
        `k8s_namespace` varchar(63) collate utf8mb4_general_ci default null,
        `flink_image` varchar(128) collate utf8mb4_general_ci default null,
        `state` int default null,
        `restart_size` int default null,
        `restart_count` int default null,
        `cp_threshold` int default null,
        `cp_max_failure_interval` int default null,
        `cp_failure_rate_interval` int default null,
        `cp_failure_action` tinyint default null,
        `dynamic_properties` longtext collate utf8mb4_general_ci,
        `description` varchar(255) collate utf8mb4_general_ci default null,
        `resolve_order` tinyint default null,
        `k8s_rest_exposed_type` tinyint default null,
        `jm_memory` int default null,
        `tm_memory` int default null,
        `total_task` int default null,
        `total_tm` int default null,
        `total_slot` int default null,
        `available_slot` int default null,
        `option_state` tinyint default null,
        `tracking` tinyint default null,
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        `option_time` datetime default null,
        `release` tinyint default 1,
        `build` tinyint default 1,
        `start_time` datetime default null,
        `end_time` datetime default null,
        `alert_id` bigint default null,
        `k8s_pod_template` longtext collate utf8mb4_general_ci,
        `k8s_jm_pod_template` longtext collate utf8mb4_general_ci,
        `k8s_tm_pod_template` longtext collate utf8mb4_general_ci,
        `k8s_hadoop_integration` tinyint default 0,
        `flink_cluster_id` bigint default null,
        `ingress_template` text collate utf8mb4_general_ci,
        `default_mode_ingress` text collate utf8mb4_general_ci,
        `tags` varchar(500) default null,
        primary key (`id`) using btree,
        key `inx_job_type` (`job_type`) using btree,
        key `inx_track` (`tracking`) using btree,
        index `inx_team` (`team_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_flink_config
    -- ----------------------------
    drop table if exists `t_flink_config`;

    create table `t_flink_config` (
        `id` bigint not null auto_increment,
        `app_id` bigint not null,
        `format` tinyint not null default 0,
        `version` int not null,
        `latest` tinyint not null default 0,
        `content` text collate utf8mb4_general_ci not null,
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_flink_effective
    -- ----------------------------
    drop table if exists `t_flink_effective`;

    create table `t_flink_effective` (
        `id` bigint not null auto_increment,
        `app_id` bigint not null,
        `target_type` tinyint not null comment '1) config 2) flink sql',
        `target_id` bigint not null comment 'configid or sqlid',
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree,
        unique key `un_effective_inx` (`app_id`, `target_type`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_flink_env
    -- ----------------------------
    drop table if exists `t_flink_env`;

    create table `t_flink_env` (
        `id` bigint not null auto_increment comment 'id',
        `flink_name` varchar(128) collate utf8mb4_general_ci not null comment 'flink instance name',
        `flink_home` varchar(255) collate utf8mb4_general_ci not null comment 'flink home path',
        `version` varchar(64) collate utf8mb4_general_ci not null comment 'flink version',
        `scala_version` varchar(64) collate utf8mb4_general_ci not null comment 'scala version of flink',
        `flink_conf` text collate utf8mb4_general_ci not null comment 'flink-conf',
        `is_default` tinyint not null default 0 comment 'whether default version or not',
        `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree,
        unique key `un_env_name` (`flink_name`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_flink_log
    -- ----------------------------
    drop table if exists `t_flink_log`;

    create table `t_flink_log` (
        `id` bigint not null auto_increment,
        `app_id` bigint default null,
        `yarn_app_id` varchar(64) collate utf8mb4_general_ci default null,
        `job_manager_url` varchar(255) collate utf8mb4_general_ci default null,
        `success` tinyint default null,
        `exception` text collate utf8mb4_general_ci,
        `option_time` datetime default null,
        `option_name` tinyint default null,
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_flink_project
    -- ----------------------------
    drop table if exists `t_flink_project`;

    create table `t_flink_project` (
        `id` bigint not null auto_increment,
        `team_id` bigint not null,
        `name` varchar(255) collate utf8mb4_general_ci default null,
        `url` varchar(255) collate utf8mb4_general_ci default null,
        `branches` varchar(64) collate utf8mb4_general_ci default null,
        `user_name` varchar(64) collate utf8mb4_general_ci default null,
        `password` varchar(64) collate utf8mb4_general_ci default null,
        `prvkey_path` varchar(128) collate utf8mb4_general_ci default null,
        `pom` varchar(255) collate utf8mb4_general_ci default null,
        `build_args` varchar(255) default null,
        `type` tinyint default null,
        `repository` tinyint default null,
        `last_build` datetime default null,
        `description` varchar(255) collate utf8mb4_general_ci default null,
        `build_state` tinyint default -1,
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`id`) using btree,
        index `inx_team` (`team_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_flink_savepoint
    -- ----------------------------
    drop table if exists `t_flink_savepoint`;

    create table `t_flink_savepoint` (
        `id` bigint not null auto_increment,
        `app_id` bigint not null,
        `chk_id` bigint default null,
        `type` tinyint default null,
        `path` varchar(255) collate utf8mb4_general_ci default null,
        `latest` tinyint not null default 1,
        `trigger_time` datetime default null,
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_flink_sql
    -- ----------------------------
    drop table if exists `t_flink_sql`;

    create table `t_flink_sql` (
        `id` bigint not null auto_increment,
        `app_id` bigint default null,
        `sql` text collate utf8mb4_general_ci,
        `dependency` text collate utf8mb4_general_ci,
        `version` int default null,
        `candidate` tinyint not null default 1,
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_menu
    -- ----------------------------
    drop table if exists `t_menu`;

    create table `t_menu` (
        `menu_id` bigint not null auto_increment comment 'menu/button id',
        `parent_id` bigint not null comment 'parent menu id',
        `menu_name` varchar(64) collate utf8mb4_general_ci not null comment 'menu button name',
        `path` varchar(64) collate utf8mb4_general_ci default null comment 'routing path',
        `component` varchar(64) collate utf8mb4_general_ci default null comment 'routing component component',
        `perms` varchar(64) collate utf8mb4_general_ci default null comment 'authority id',
        `icon` varchar(64) collate utf8mb4_general_ci default null comment 'icon',
        `type` char(2) collate utf8mb4_general_ci default null comment 'type 0:menu 1:button',
        `display` tinyint collate utf8mb4_general_ci not null default 1 comment 'whether the menu is displayed',
        `order_num` int default null comment 'sort',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`menu_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_message
    -- ----------------------------
    drop table if exists `t_message`;

    create table `t_message` (
        `id` bigint not null auto_increment,
        `app_id` bigint default null,
        `user_id` bigint default null,
        `type` tinyint default null,
        `title` varchar(255) collate utf8mb4_general_ci default null,
        `context` text collate utf8mb4_general_ci,
        `is_read` tinyint default 0,
        `create_time` datetime default null comment 'create time',
        primary key (`id`) using btree,
        key `inx_mes_user` (`user_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_team
    -- ----------------------------
    drop table if exists `t_team`;

    create table `t_team` (
        `id` bigint not null auto_increment comment 'team id',
        `team_name` varchar(64) collate utf8mb4_general_ci not null comment 'team name',        `description` varchar(255) collate utf8mb4_general_ci default null,
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`id`) using btree,
        unique key `team_name_idx` (`team_name`) using btree
    ) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_variable
    -- ----------------------------
    drop table if exists `t_variable`;

    create table `t_variable` (
        `id` bigint not null auto_increment,
        `variable_code` varchar(128) collate utf8mb4_general_ci not null comment 'Variable code is used for parameter names passed to the program or as placeholders',
        `variable_value` text collate utf8mb4_general_ci not null comment 'The specific value corresponding to the variable',
        `description` text collate utf8mb4_general_ci default null comment 'More detailed description of variables',
        `creator_id` bigint collate utf8mb4_general_ci not null comment 'user id of creator',
        `team_id` bigint collate utf8mb4_general_ci not null comment 'team id',
        `desensitization` tinyint not null default 0 comment '0 is no desensitization, 1 is desensitization, if set to desensitization, it will be replaced by * when displayed',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`id`) using btree,
        unique key `un_team_vcode_inx` (`team_id`, `variable_code`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_role
    -- ----------------------------
    drop table if exists `t_role`;

    create table `t_role` (
        `role_id` bigint not null auto_increment comment 'user id',
        `role_name` varchar(64) collate utf8mb4_general_ci not null comment 'role name',        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
        primary key (`role_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_role_menu
    -- ----------------------------
    drop table if exists `t_role_menu`;

    create table `t_role_menu` (
        `id` bigint not null auto_increment,
        `role_id` bigint not null,
        `menu_id` bigint not null,
        primary key (`id`) using btree,
        unique key `un_role_menu_inx` (`role_id`, `menu_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_setting
    -- ----------------------------
    drop table if exists `t_setting`;

    create table `t_setting` (
        `order_num` int default null,
        `setting_key` varchar(64) collate utf8mb4_general_ci not null,
        `setting_value` text collate utf8mb4_general_ci default null,
        `setting_name` varchar(255) collate utf8mb4_general_ci default null,
        `description` varchar(255) collate utf8mb4_general_ci default null,
        `type` tinyint not null comment '1: input 2: boolean 3: number',
        primary key (`setting_key`) using btree
    ) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_user
    -- ----------------------------
    drop table if exists `t_user`;

    create table `t_user` (
        `user_id` bigint not null auto_increment comment 'user id',
        `username` varchar(64) collate utf8mb4_general_ci not null comment 'user name',
        `nick_name` varchar(64) collate utf8mb4_general_ci not null comment 'nick name',        `salt` varchar(26) collate utf8mb4_general_ci default null comment 'salt',
        `password` varchar(64) collate utf8mb4_general_ci not null comment 'password',
        `email` varchar(64) collate utf8mb4_general_ci default null comment 'email',
        `user_type` int not null comment 'user type 1:admin 2:user',
        `login_type` tinyint default 0 comment 'login type 0:password 1:ldap',
        `last_team_id` bigint default null comment 'last team id',
        `status` char(1) collate utf8mb4_general_ci not null comment 'status 0:locked 1:active',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        `last_login_time` datetime default null comment 'last login time',
        `sex` char(1) collate utf8mb4_general_ci default null comment 'gender 0:male 1:female 2:confidential',
        `avatar` varchar(128) collate utf8mb4_general_ci default null comment 'avatar',
        `description` varchar(255) collate utf8mb4_general_ci default null comment 'description',
        primary key (`user_id`) using btree,
        unique key `un_username` (`username`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table structure for t_member
    -- ----------------------------
    drop table if exists `t_member`;

    create table `t_member` (
        `id` bigint not null auto_increment,
        `team_id` bigint not null comment 'team id',
        `user_id` bigint not null comment 'user id',
        `role_id` bigint not null comment 'role id',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`id`) using btree,
        unique key `un_user_team_role_inx` (`user_id`, `team_id`, `role_id`) using btree    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_app_build_pipe
    -- ----------------------------
    drop table if exists `t_app_build_pipe`;

    create table `t_app_build_pipe`(
        `app_id` bigint,
        `pipe_type` tinyint,
        `pipe_status` tinyint,
        `cur_step` smallint,
        `total_step` smallint,
        `steps_status` text,
        `steps_status_ts` text,
        `error` text,
        `build_result` text,
        `modify_time` datetime default null comment 'modify time',
        primary key (`app_id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_flink_cluster
    -- ----------------------------
    drop table if exists `t_flink_cluster`;

    create table `t_flink_cluster` (
        `id` bigint not null auto_increment,
        `address` varchar(150) default null comment 'url address of jobmanager',
        `cluster_id` varchar(45) default null comment 'clusterid of session mode(yarn-session:application-id,k8s-session:cluster-id)',
        `cluster_name` varchar(128) not null comment 'cluster name',
        `options` longtext comment 'json form of parameter collection ',
        `yarn_queue` varchar(128) default null comment 'the yarn queue where the task is located',
        `execution_mode` tinyint not null default 1 comment 'k8s execution session mode(1:remote,3:yarn-session,5:kubernetes-session)',
        `version_id` bigint not null comment 'flink version id',
        `k8s_namespace` varchar(63) default 'default' comment 'k8s namespace',
        `service_account` varchar(64) default null comment 'k8s service account',
        `description` varchar(255) default null,
        `user_id` bigint default null,
        `flink_image` varchar(128) default null comment 'flink image',
        `dynamic_properties` longtext comment 'allows specifying multiple generic configuration options',
        `k8s_rest_exposed_type` tinyint default 2 comment 'k8s export(0:loadbalancer,1:clusterip,2:nodeport)',
        `k8s_hadoop_integration` tinyint default 0,
        `k8s_conf` varchar(255) default null comment 'the path where the k8s configuration file is located',
        `resolve_order` int default null,
        `exception` longtext comment 'exception information',
        `cluster_state` tinyint default 0 comment 'cluster status (0: created but not started, 1: started, 2: stopped)',
        `create_time` datetime default null comment 'create time',
        primary key (`id`, `cluster_name`),
        unique key `id` (`cluster_id`, `address`, `execution_mode`)
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_access_token definition
    -- ----------------------------
    drop table if exists `t_access_token`;

    create table `t_access_token` (
        `id` int not null auto_increment comment 'key',
        `user_id` bigint,
        `token` varchar(1024) character set utf8mb4 collate utf8mb4_general_ci default null comment 'token',
        `expire_time` datetime default null comment 'expiration',
        `description` varchar(255) character set utf8mb4 collate utf8mb4_general_ci default null comment 'description',
        `status` tinyint default null comment '1:enable,0:disable',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        primary key (`id`) using btree
    ) engine = innodb auto_increment = 100000 default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_alert_config
    -- ----------------------------
    drop table if exists `t_alert_config`;

    create table `t_alert_config` (
        `id` bigint not null auto_increment primary key,
        `user_id` bigint default null,
        `alert_name` varchar(128) collate utf8mb4_general_ci default null comment 'alert group name',
        `alert_type` int default 0 comment 'alert type',
        `email_params` varchar(255) collate utf8mb4_general_ci comment 'email params',
        `sms_params` text collate utf8mb4_general_ci comment 'sms params',
        `ding_talk_params` text collate utf8mb4_general_ci comment 'ding talk params',
        `we_com_params` varchar(255) collate utf8mb4_general_ci comment 'wechat params',        `http_callback_params` text collate utf8mb4_general_ci comment 'http callback params',
        `lark_params` text collate utf8mb4_general_ci comment 'lark params',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        index `inx_alert_user` (`user_id`) using btree
    ) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- Table of t_external_link
    -- ----------------------------
    drop table if exists `t_external_link`;

    CREATE TABLE `t_external_link` (
        `id` bigint not null auto_increment primary key,
        `badge_label` varchar(64) collate utf8mb4_general_ci default null,
        `badge_name` varchar(64) collate utf8mb4_general_ci default null,
        `badge_color` varchar(64) collate utf8mb4_general_ci default null,
        `link_url` varchar(255) collate utf8mb4_general_ci default null,
        `create_time` datetime default null COMMENT 'create time',
        `modify_time` datetime default null COMMENT 'modify time'
    ) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

    -- ----------------------------
    -- table structure for t_yarn_queue
    -- ----------------------------
    drop table if exists `t_yarn_queue`;

    create table `t_yarn_queue` (
        `id` bigint not null primary key auto_increment comment 'queue id',
        `team_id` bigint not null comment 'team id',
        `queue_label` varchar(128) collate utf8mb4_general_ci not null comment 'queue label expression',
        `description` varchar(255) collate utf8mb4_general_ci default null comment 'description of the queue label',
        `create_time` datetime default null comment 'create time',
        `modify_time` datetime default null comment 'modify time',
        unique key `unq_team_id_queue_label` (`team_id`, `queue_label`) using btree
    ) engine = innodb default charset = utf8mb4 collate = utf8mb4_general_ci;

    set
        foreign_key_checks = 1;

    -- ----------------------------
    -- Records of t_team
    -- ----------------------------
    insert into
        `t_team`
    values
        (100000, 'default', null, now(), now());

    -- ----------------------------
    -- Records of t_flink_app
    -- ----------------------------
    insert into
        `t_flink_app`
    values
        (
            100000,
            100000,
            2,
            4,
            null,
            null,
            'Flink SQL Demo',
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            100000,
            1,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            '0',
            0,
            null,
            null,
            null,
            null,
            null,
            null,
            'Flink SQL Demo',
            0,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            0,
            0,
            now(),
            now(),
            null,
            1,
            1,
            null,
            null,
            null,
            null,
            null,
            null,
            0,
            null,
            null,
            null,
            'streampark,test'
        );

    -- ----------------------------
    -- Records of t_flink_effective
    -- ----------------------------
    insert into
        `t_flink_effective`
    values
        (100000, 100000, 2, 100000, now());

    -- ----------------------------
    -- Records of t_flink_project
    -- ----------------------------
    insert into
        `t_flink_project`
    values
        (
            100000,
            100000,
            'streampark-quickstart',
            'https://github.com/apache/incubator-streampark-quickstart',
            'release-2.0.0',
            null,
            null,
            null,
            null,
            null,
            1,
            1,
            null,
            'streampark-quickstart',
            -1,
            now(),
            now()
        );

    -- ----------------------------
    -- Records of t_flink_sql
    -- ----------------------------
    insert into
        `t_flink_sql`
    values
        (
            100000,
            100000,
            'eNqlUUtPhDAQvu+vmFs1AYIHT5s94AaVqGxSSPZIKgxrY2mxrdGfb4GS3c0+LnJo6Mz36syapkmZQpk8vKbQMMt2KOFmAe5rK4Nf3yhrhCwvA1/TTDaqO61UxmooSprlT1PDGkgKEKpmwvIOjWVdP3W2zpG+JfQFHjfU46xxrVvYZuWztye1khJrqzSBFRCfjUwSYQiqt1xJJvyPcbWJp9WPCXvUoUEn0ZAVufcs0nIUjYn2L4s++YiY75eBLr+2Dnl3GYKTWRyfQKYRRR2XZxXmNvu9yh9GHAmUO/sxyMRkGNly4c714RZ7zaWtLHsX+N9NjvVrWxm99jmyvEhpOUhujmIYFI5zkCOYzYIj11a7QH7Tyz+nE8bw',
            null,
            1,
            1,
            now()
        );

    -- ----------------------------
    -- Records of t_menu
    -- ----------------------------
    insert into
        `t_menu`
    values
        (
            110000,
            0,
            'menu.system',
            '/system',
            'PageView',
            null,
            null,
            '0',
            1,
            3,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120000,
            0,
            'Apache Flink',
            '/flink',
            'PageView',
            null,
            null,
            '0',
            1,
            1,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130000,
            0,
            'menu.setting',
            '/setting',
            'PageView',
            null,
            null,
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110100,
            110000,
            'menu.userManagement',
            '/system/user',
            'system/user/User',
            null,
            'user',
            '0',
            1,
            1,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110200,
            110000,
            'menu.roleManagement',
            '/system/role',
            'system/role/Role',
            null,
            'smile',
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110300,
            110000,
            'menu.menuManagement',
            '/system/menu',
            'system/menu/Menu',
            'menu:view',
            'bars',
            '0',
            1,
            3,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110400,
            110000,
            'menu.tokenManagement',
            '/system/token',
            'system/token/Token',
            null,
            'lock',
            '0',
            1,
            1,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110500,
            110000,
            'menu.teamManagement',
            '/system/team',
            'system/team/Team',
            null,
            'team',
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110600,
            110000,
            'menu.memberManagement',
            '/system/member',
            'system/member/Member',
            null,
            'usergroup-add',
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120100,
            120000,
            'menu.project',
            '/flink/project',
            'flink/project/View',
            null,
            'github',
            '0',
            1,
            1,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120200,
            120000,
            'menu.application',
            '/flink/app',
            'flink/app/View',
            null,
            'mobile',
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120300,
            120000,
            'menu.variable',
            '/flink/variable',
            'flink/variable/View',
            null,
            'code',
            '0',
            1,
            3,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130100,
            130000,
            'setting.system',
            '/setting/system',
            'setting/System/index',
            null,
            'database',
            '0',
            1,
            1,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130200,
            130000,
            'setting.alarm',
            '/setting/alarm',
            'setting/Alarm/index',
            null,
            'alert',
            '0',
            1,
            2,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130300,
            130000,
            'setting.flinkHome',
            '/setting/flinkHome',
            'setting/FlinkHome/index',
            null,
            'desktop',
            '0',
            1,
            3,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130400,
            130000,
            'setting.flinkCluster',
            '/setting/flinkCluster',
            'setting/FlinkCluster/index',
            'menu:view',
            'cluster',
            '0',
            1,
            4,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130500,
            130000,
            'setting.externalLink',
            '/setting/externalLink',
            'setting/ExternalLink/index',
            'menu:view',
            'link',
            '0',
            1,
            5,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130600,
            130000,
            'setting.yarnQueue',
            '/setting/yarnQueue',
            'setting/YarnQueue/index',
            'menu:view',
            'bars',
            '0',
            1,
            6,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110101,
            110100,
            'add',
            null,
            null,
            'user:add',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110102,
            110100,
            'update',
            null,
            null,
            'user:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110103,
            110100,
            'delete',
            null,
            null,
            'user:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110104,
            110100,
            'reset',
            null,
            null,
            'user:reset',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110105,
            110100,
            'types',
            null,
            null,
            'user:types',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110106,
            110100,
            'view',
            null,
            null,
            'user:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110201,
            110200,
            'add',
            null,
            null,
            'role:add',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110202,
            110200,
            'update',
            null,
            null,
            'role:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110203,
            110200,
            'delete',
            null,
            null,
            'role:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110204,
            110200,
            'view',
            null,
            null,
            'role:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110401,
            110400,
            'add',
            null,
            null,
            'token:add',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110402,
            110400,
            'delete',
            null,
            null,
            'token:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110403,
            110400,
            'view',
            null,
            null,
            'token:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110501,
            110500,
            'add',
            null,
            null,
            'team:add',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110502,
            110500,
            'update',
            null,
            null,
            'team:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110503,
            110500,
            'delete',
            null,
            null,
            'team:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110504,
            110500,
            'view',
            null,
            null,
            'team:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110601,
            110600,
            'add',
            null,
            null,
            'member:add',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110602,
            110600,
            'update',
            null,
            null,
            'member:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110603,
            110600,
            'delete',
            null,
            null,
            'member:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110604,
            110600,
            'role view',
            null,
            null,
            'role:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            110605,
            110600,
            'view',
            null,
            null,
            'member:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120101,
            120100,
            'add',
            '/flink/project/add',
            'flink/project/Add',
            'project:create',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120102,
            120100,
            'build',
            null,
            null,
            'project:build',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120103,
            120100,
            'delete',
            null,
            null,
            'project:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120104,
            120100,
            'edit',
            '/flink/project/edit',
            'flink/project/Edit',
            'project:update',
            null,
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120105,
            120100,
            'view',
            null,
            null,
            'project:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120201,
            120200,
            'add',
            '/flink/app/add',
            'flink/app/Add',
            'app:create',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120202,
            120200,
            'detail app',
            '/flink/app/detail',
            'flink/app/Detail',
            'app:detail',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120203,
            120200,
            'edit flink',
            '/flink/app/edit_flink',
            'flink/app/EditFlink',
            'app:update',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120204,
            120200,
            'edit streampark',
            '/flink/app/edit_streampark',
            'flink/app/EditStreamPark',
            'app:update',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120205,
            120200,
            'mapping',
            null,
            null,
            'app:mapping',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120206,
            120200,
            'release',
            null,
            null,
            'app:release',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120207,
            120200,
            'start',
            null,
            null,
            'app:start',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120208,
            120200,
            'clean',
            null,
            null,
            'app:clean',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120209,
            120200,
            'cancel',
            null,
            null,
            'app:cancel',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120210,
            120200,
            'savepoint delete',
            null,
            null,
            'savepoint:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120211,
            120200,
            'backup rollback',
            null,
            null,
            'backup:rollback',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120212,
            120200,
            'backup delete',
            null,
            null,
            'backup:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120213,
            120200,
            'conf delete',
            null,
            null,
            'conf:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120214,
            120200,
            'delete',
            null,
            null,
            'app:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120215,
            120200,
            'copy',
            null,
            null,
            'app:copy',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120216,
            120200,
            'view',
            null,
            null,
            'app:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120217,
            120200,
            'savepoint trigger',
            null,
            null,
            'savepoint:trigger',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120218,
            120200,
            'sql delete',
            null,
            null,
            'sql:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120301,
            120300,
            'add',
            NULL,
            NULL,
            'variable:add',
            NULL,
            '1',
            1,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120302,
            120300,
            'update',
            NULL,
            NULL,
            'variable:update',
            NULL,
            '1',
            1,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120303,
            120300,
            'delete',
            NULL,
            NULL,
            'variable:delete',
            NULL,
            '1',
            1,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120304,
            120300,
            'depend apps',
            '/flink/variable/depend_apps',
            'flink/variable/DependApps',
            'variable:depend_apps',
            '',
            '0',
            0,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120305,
            120300,
            'show original',
            NULL,
            NULL,
            'variable:show_original',
            NULL,
            '1',
            1,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120306,
            120300,
            'view',
            NULL,
            NULL,
            'variable:view',
            NULL,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            120307,
            120300,
            'depend view',
            null,
            null,
            'variable:depend_apps',
            null,
            '1',
            1,
            NULL,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130101,
            130100,
            'view',
            null,
            null,
            'setting:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130102,
            130100,
            'setting update',
            null,
            null,
            'setting:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130401,
            130400,
            'add cluster',
            '/setting/add_cluster',
            'setting/FlinkCluster/AddCluster',
            'cluster:create',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130402,
            130400,
            'edit cluster',
            '/setting/edit_cluster',
            'setting/FlinkCluster/EditCluster',
            'cluster:update',
            '',
            '0',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130501,
            130500,
            'link view',
            null,
            null,
            'externalLink:view',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130502,
            130500,
            'link create',
            null,
            null,
            'externalLink:create',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130503,
            130500,
            'link update',
            null,
            null,
            'externalLink:update',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130504,
            130500,
            'link delete',
            null,
            null,
            'externalLink:delete',
            null,
            '1',
            1,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130601,
            130600,
            'add yarn queue',
            null,
            null,
            'yarnQueue:create',
            '',
            '1',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130602,
            130600,
            'edit yarn queue',
            null,
            null,
            'yarnQueue:update',
            '',
            '1',
            0,
            null,
            now(),
            now()
        );

    insert into
        `t_menu`
    values
        (
            130603,
            130600,
            'delete yarn queue',
            null,
            null,
            'yarnQueue:delete',
            '',
            '1',
            0,
            null,
            now(),
            now()
        );

    -- ----------------------------
    -- Records of t_role
    -- ----------------------------
    insert into
        `t_role`
    values
        (100001, 'developer', now(), now(), 'developer');

    insert into
        `t_role`
    values
        (
            100002,
            'team admin',
            now(),
            now(),
            'Team Admin has all permissions inside the team.'
        );

    -- ----------------------------
    -- Records of t_role_menu
    -- ----------------------------
    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120000);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120100);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120101);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120102);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120104);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120105);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120200);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120201);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120202);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120203);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120204);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120206);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120207);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120208);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120209);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120210);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120211);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120212);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120213);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120215);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120216);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120217);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120300);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120304);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120306);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 120307);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 130000);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 130100);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100001, 130101);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110000);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110600);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110601);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110602);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110603);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110604);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 110605);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120000);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120100);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120101);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120102);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120103);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120104);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120105);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120200);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120201);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120202);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120203);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120204);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120205);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120206);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120207);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120208);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120209);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120210);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120211);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120212);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120213);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120214);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120215);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120216);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120217);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120218);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120300);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120301);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120302);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120303);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120304);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120305);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120306);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 120307);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130000);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130100);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130101);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130200);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130300);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130400);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130401);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130402);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130500);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130501);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130502);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130503);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130504);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130600);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130601);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130602);

    insert into
        `t_role_menu` (role_id, menu_id)
    values
        (100002, 130603);

    -- ----------------------------
    -- Records of t_setting
    -- ----------------------------
    insert into
        `t_setting`
    values
        (
            1,
            'streampark.maven.settings',
            null,
            'Maven Settings File Path',
            'Maven Settings.xml full path',
            1
        );

    insert into
        `t_setting`
    values
        (
            2,
            'streampark.maven.central.repository',
            null,
            'Maven Central Repository',
            'Maven private server address',
            1
        );

    insert into
        `t_setting`
    values
        (
            3,
            'streampark.maven.auth.user',
            null,
            'Maven Central Repository Auth User',
            'Maven private server authentication username',
            1
        );

    insert into
        `t_setting`
    values
        (
            4,
            'streampark.maven.auth.password',
            null,
            'Maven Central Repository Auth Password',
            'Maven private server authentication password',
            1
        );

    insert into
        `t_setting`
    values
        (
            5,
            'alert.email.host',
            null,
            'Alert Email Smtp Host',
            'Alert Mailbox Smtp Host',
            1
        );

    insert into
        `t_setting`
    values
        (
            6,
            'alert.email.port',
            null,
            'Alert Email Smtp Port',
            'Smtp Port of the alarm mailbox',
            1
        );

    insert into
        `t_setting`
    values
        (
            7,
            'alert.email.from',
            null,
            'Alert Sender Email',
            'Email to send alerts',
            1
        );

    insert into
        `t_setting`
    values
        (
            8,
            'alert.email.userName',
            null,
            'Alert  Email User',
            'Authentication username used to send alert emails',
            1
        );

    insert into
        `t_setting`
    values
        (
            9,
            'alert.email.password',
            null,
            'Alert Email Password',
            'Authentication password used to send alarm email',
            1
        );

    insert into
        `t_setting`
    values
        (
            10,
            'alert.email.ssl',
            'false',
            'Alert Email SSL',
            'Whether to enable SSL in the mailbox that sends the alert',
            2
        );

    insert into
        `t_setting`
    values
        (
            11,
            'docker.register.address',
            null,
            'Docker Register Address',
            'Docker container service address',
            1
        );

    insert into
        `t_setting`
    values
        (
            12,
            'docker.register.user',
            null,
            'Docker Register User',
            'Docker container service authentication username',
            1
        );

    insert into
        `t_setting`
    values
        (
            13,
            'docker.register.password',
            null,
            'Docker Register Password',
            'Docker container service authentication password',
            1
        );

    insert into
        `t_setting`
    values
        (
            14,
            'docker.register.namespace',
            null,
            'Docker namespace',
            'Namespace for docker image used in docker building env and target image register',
            1
        );

    insert into
        `t_setting`
    values
        (
            15,
            'ingress.mode.default',
            null,
            'Ingress domain address',
            'Automatically generate an nginx-based ingress by passing in a domain name',            1
        );

    -- ----------------------------
    -- Records of t_user
    -- ----------------------------
    insert into
        `t_user`
    values
        (
            100000,
            'admin',
            '',
            'rh8b1ojwog777yrg0daesf04gk',
            '2513f3748847298ea324dffbf67fe68681dd92315bda830065facd8efe08f54f',
            null,
            1,
            0,
            null,
            '1',
            now(),
            now(),
            null,
            0,
            null,
            null
        );

    -- ----------------------------
    -- Records of t_member
    -- ----------------------------
    insert into
        `t_member`
    values
        (100000, 100000, 100000, 100001, now(), now());

    set
        foreign_key_checks = 1;