# from flask import Flask, request, jsonify
# from flask_cors import CORS
# import tensorflow as tf
# import numpy as np
# from PIL import Image
# import io

# app = Flask(__name__)
# CORS(app)  # Allow Flutter to call API

# # Load a pretrained Keras model (example: trained on PlantVillage dataset)
# MODEL = tf.keras.models.load_model("plant_disease_model.h5")

# # Sample recovery info
# RECOVERY_GUIDE = {
#     "Tomato Early Blight": "Remove affected leaves, use copper fungicide, rotate crops.",
#     "Tomato Late Blight": "Spray chlorothalonil fungicide, remove infected plants.",
#     "Potato Black Scurf": "Use certified seed, crop rotation, well-drained soil."
# }

# @app.route("/api/disease-diagnosis", methods=["POST"])
# def diagnose():
#     if "image" not in request.files:
#         return jsonify({"error": "No image uploaded"}), 400

#     image = request.files["image"].read()
#     img = Image.open(io.BytesIO(image)).resize((128, 128))
#     img_array = np.expand_dims(np.array(img) / 255.0, axis=0)

#     prediction = MODEL.predict(img_array)
#     predicted_class = np.argmax(prediction, axis=1)[0]

#     # Example mapping: Adjust with your actual class labels
#     class_names = ["Tomato Early Blight", "Tomato Late Blight", "Potato Black Scurf"]
#     disease_name = class_names[predicted_class]
#     recovery = RECOVERY_GUIDE.get(disease_name, "No recovery steps available.")

#     return jsonify({"disease": disease_name, "recovery": recovery})

# if __name__ == "__main__":
#     app.run(debug=True, port=5001)

from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from flask_cors import CORS
import numpy as np
from PIL import Image

app = Flask(__name__)
CORS(app) 
# Load model once at start
MODEL = load_model("plant_disease_model.h5")  # ✅ Make sure this file is in the same folder

@app.route('/api/disease-diagnosis', methods=['POST'])
def disease_diagnosis():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    # Read and preprocess image
    img = Image.open(request.files['image'].stream).resize((224, 224))
    arr = np.expand_dims(np.array(img) / 255.0, axis=0)

    # 🔹 TODO: Add your model prediction here
    # preds = MODEL.predict(arr)
    # predicted_class = np.argmax(preds, axis=1)[0]

    # Temporary Dummy Response
    prediction = "Leaf Blight"
    recovery = "Spray copper-based fungicide and ensure proper irrigation."

    return jsonify({
        'disease': prediction,
        'recovery': recovery
    })

if __name__ == '__main__':
    # ✅ IMPORTANT: Use 0.0.0.0 so it's visible in local network
    app.run(host="0.0.0.0", port=5001, debug=True)
