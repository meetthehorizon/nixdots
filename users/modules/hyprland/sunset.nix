{lib, ...}: {
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "22:00";
          temperature = "3000";
          gamma = 0.9;
        }
      ];
    };
  };

  systemd.user.services.hyprsunset.Install.WantedBy = lib.mkForce [];
}
