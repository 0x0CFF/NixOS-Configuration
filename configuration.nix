# 编辑此配置文件以定义应在系统上安装的内容
# 帮助位于 configuration.nix（5） 手册页中，位于 https://search.nixos.org/options 以及 NixOS 手册 ('nixos-help')

{ config, lib, pkgs, ... }:

{
  imports =
    [ # 硬件表
      ./hardware-configuration.nix
    ];


  # 系统引导
  boot.loader = {
    # 使用 systemd-boot EFI 引导加载程序
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
    # 使用 GRUB 引导加载程序
    # grub.enable = true;
    # grub.device = "nodev";
  };


  # 网络配置
  networking = {
    
    # 定义主机名
    hostName = "NODENS00";
    
    # 配置网络管理工具，仅选择以下网络选项之一
    # wireless.enable = true;      # 通过 wpa_supplicant 启用无线支持
    networkmanager.enable = true;  # 易于使用的网络管理工具（大多数发行版默认使用它）
    
    # 网络代理配置，格式："http://user:password@proxy:port/"
    proxy = {
      # default = "http://192.168.31.xx:20171/";            # [Server] V2ray 非分流端口
      # default = "http://192.168.31.xx:20172/";            # [Server] V2ray 分流端口
      # noProxy = "127.0.0.1,localhost,internal.domain";
    };

    # 防火墙端口配置
    firewall = {
      enable = true;                  # 防火墙开关
      allowPing = true;
      allowedTCPPorts = [ 8384 ];     # 打开防火墙中的端口
      # allowedUDPPorts = [ ... ];
    };

  };


  # 设置时区
  time.timeZone = "Asia/Shanghai";


  # 本地化与输入法
  i18n.defaultLocale = "zh_CN.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  # 系统服务
  services = {

    # X 图形显示服务器
    xserver = {
      enable = true;
      # xkb.layout = "us";                       # X11 键盘布局       
      # xkb.options = "eurosign:e,caps:escape";  # X11 键盘映射
    };

    # 在没有 GNOME 桌面环境的情况下使用 Nautilus 时，需要启用 GVfs 服务才能使垃圾箱、网络文件系统正常工作
    gvfs = {
      enable = true;
    };

    # SSH 服务
    openssh = {
      enable = true;
    };

    # 同步服务
    syncthing = {
      enable = true;
      user = "0x0CFF";
      dataDir = "/home/0x0CFF";
      guiAddress = "0.0.0.0:8384";
    };

    # 启用 CUPS 以打印文档
    # printing.enable = true;

    # 启用触摸板支持（在大多数桌面管理器中默认启用）
    # libinput.enable = true;                  
  };


  # 启用声音（pulseaudio 与 pipewire 服务互斥）
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };


  # 定义用户，不要忘记使用「passwd」设置密码
  users.users."0x0CFF" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];     # 为该用户启用 sudo 权限
    packages = with pkgs; [
      # tree
    ];
  };


  # 列出 system profile 中安装的软件包
  # 要搜索，请运行：$ nix search wget
  environment.systemPackages = with pkgs; [
    helix       # 不要忘记添加编辑器来编辑 configuration.nix，默认情况下，还会安装 Nano 编辑器
    firefox
    yazi
    fastfetch
    alacritty
    git
    bottom
    navi
  ];


  # 系统程序
  programs = {
    
    # Hyprland 桌面
    hyprland = {
      enable = true;
    };
    
    # 配置 Bash
    bash = {
      # Tab 补全功能
      completion.enable = true;
      # 初始化交互式 shell 时应运行的额外命令
      # 加载 Bash 快捷键
      shellInit = "bind -f '/home/0x0CFF/Syncthing/Private/Profiles/NixOS/Composers/Environment/Dotfiles/bash/bind'";

      # 设置命令别名方便使用
      shellAliases = {
        NAVI = "navi --path '/home/0x0CFF/Syncthing/Private/Profiles/NixOS/Composers/Environment/Dotfiles/navi'";
      };
    };

  };


  nix = {
    # 系统特性
    settings = {
        # 定义 channels 国内源
        # substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
        # 启用 nix-command、flaskes 特性
        experimental-features = [ "nix-command" "flakes" ];
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # 复制 NixOS 配置文件并将其从生成的系统中链接，(/run/current-system/configuration.nix)，这在意外删除 configuration.nix 时很有用
  # system.copySystemConfiguration = true;

  # 这个选项定义了你在这台机器上安装的第一个 NixOS 版本，用于保持与旧版 NixOS 上创建的应用程序数据（例如数据库）的兼容性
  # 大多数用户在初始安装后，无论出于何种原因都不应该更改这个值，即使你已经将系统升级到新的 NixOS 版本
  #
  # 这个值不会影响你的软件包和操作系统的 Nixpkgs 版本
  # 所以改变它不会升级你的系统——请参 https://nixos.org/manual/nixos/stable/#sec-upgrading 了解如何实际执行此操作
  #
  # 这个值低于当前的 NixOS 版本并不意味着你的系统过时、不受支持或容易受到攻击
  #
  # 除非您已手动检查它将对您的配置进行的所有更改，并相应地迁移了数据，否则请勿更改此值
  # 有关详细信息，请参阅 `man configuration.nix` 或 https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";  # 更改此值前，确定阅读了上面的信息?

}

