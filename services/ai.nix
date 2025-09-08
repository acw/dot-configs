{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    koboldcpp
  ];

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      #      llama-server = {
      #        image = "llama.cpp";
      #        ports = ["8081:8081"];
      #        volumes = [
      #          "/pool0/ai-models/llama.cpp:/models"
      #        ];
      #        cmd = [
      #          "./build/bin/llama-swap"
      #          "-config" "/models/models.yaml"
      #          "-listen" "0.0.0.0:8081"
      #        ];
      #      };
      #
      #      comfyui = {
      #        image = "comfy";
      #        pull = "never";
      #        ports = ["8188:8188"];
      #        volumes = [
      #          "/pool0/ai-models/comfyui:/home/comfyui/models"
      #          "/home/awick/unstability/inputs:/inputs"
      #          "/home/awick/unstability/outputs:/outputs"
      #        ];
      #        cmd = [
      #          "python3" "main.py"
      #          "--listen" "0.0.0.0"
      #          "--port" "8188"
      #          "--disable-auto-launch"
      #          "--output-directory" "/outputs"
      #          "--input-directory" "/inputs"
      #          "--cpu"
      #          "--preview-method" "taesd"
      #          "--use-pytorch-cross-attention"
      #        ];
      #      };
    };
  };
}
