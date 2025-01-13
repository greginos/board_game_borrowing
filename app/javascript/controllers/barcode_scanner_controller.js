import Quagga from "https://cdn.jsdelivr.net/npm/@ericblade/quagga2/+esm";
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["video", "result"];

  connect() {
    console.log("Barcode scanner connected");

    Quagga.init(
      {
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: document.querySelector("#video"), // Vidéo cible
          constraints: {
            width: 640,
            height: 480,
            facingMode: "environment", // Caméra arrière
          },
        },
        decoder: {
          readers: ["ean_reader"], // Types de codes-barres pris en charge
        },
      },
      (err) => {
        if (err) {
          console.error("Quagga initialization error:", err);
          return;
        }
        console.log("Quagga initialized");
        Quagga.start(); // Lancer la caméra
      }
    );

    // Dessin des cadres
    const canvas = document.querySelector("#canvas");
    const context = canvas.getContext("2d");

    Quagga.onProcessed((result) => {
      console.log("Résultat onProcessed :", result);
      context.clearRect(0, 0, canvas.width, canvas.height); // Efface le canvas

      if (result) {
        // Si des boîtes (zones détectées) sont trouvées
        if (result.boxes) {
          console.log("Zones détectées :", result.boxes);
          result.boxes
            .filter((box) => box !== undefined)
            .forEach((box) => {
              context.beginPath();
              context.moveTo(box[0][0], box[0][1]);
              context.lineTo(box[1][0], box[1][1]);
              context.lineTo(box[2][0], box[2][1]);
              context.lineTo(box[3][0], box[3][1]);
              context.closePath();
              context.lineWidth = 2;
              context.strokeStyle = "blue"; // Couleur du cadre
              context.stroke();
            });
        } else {
          console.log("Aucune zone détectée."); 
      }
    }});



    Quagga.onDetected((data) => {
      const code = data.codeResult.code;
      console.log("Code detected:", code);
      this.resultTarget.value = code; // Mettre à jour le champ
    });
  }

  disconnect() {
    window.Quagga.stop(); // Arrêter proprement la caméra lors de la déconnexion
  }
}
