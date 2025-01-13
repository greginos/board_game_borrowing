import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["video", "result"];

  connect() {
    console.log("Barcode scanner connected");

    window.Quagga.init(
      {
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: this.videoTarget, // Vidéo cible
          constraints: {
            width: 640,
            height: 480,
            facingMode: "environment", // Caméra arrière
          },
        },
        decoder: {
          readers: ["code_128_reader", "ean_reader"], // Types de codes-barres pris en charge
        },
        locate: true,
      },
      (err) => {
        if (err) {
          console.error("Quagga initialization error:", err);
          return;
        }
        console.log("Quagga initialized");
        window.Quagga.start(); // Lancer la caméra
      }
    );

    window.Quagga.onDetected((data) => {
      const code = data.codeResult.code;
      console.log("Code detected:", code);
      this.resultTarget.value = code; // Mettre à jour le champ
    });
  }

  disconnect() {
    window.Quagga.stop(); // Arrêter proprement la caméra lors de la déconnexion
  }
}
