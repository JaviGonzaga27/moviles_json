from flask import Flask, jsonify, request
import requests
import json
import base64
from flask_cors import CORS  # Asegúrate de que esto esté importado

app = Flask(__name__)

# Habilitar CORS para que las solicitudes de otros orígenes sean permitidas
CORS(app)

# El resto de tu código sigue igual...

# GitHub API URL
repo_owner = 'BrayanDaniel'
repo_name = 'Moviles'
file_path = 'verduras.json'
token = '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'  # Tu token de acceso

api_url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/contents/{file_path}'

# Ruta para obtener productos
@app.route('/productos', methods=['GET'])
def get_productos():
    response = requests.get(api_url, headers={'Authorization': f'Bearer {token}'})
    if response.status_code == 200:
        data = response.json()
        content = base64.b64decode(data['content']).decode('utf-8')
        productos = json.loads(content)
        return jsonify(productos)
    else:
        return jsonify({'error': 'No se pudieron obtener los productos'}), 400

# Ruta para editar un producto específico (PUT)
@app.route('/productos/<int:codigo>', methods=['PUT'])
def editar_producto(codigo):
    producto_actualizado = request.get_json()
    
    response = requests.get(api_url, headers={'Authorization': f'Bearer {token}'})
    if response.status_code == 200:
        data = response.json()
        content = base64.b64decode(data['content']).decode('utf-8')
        productos = json.loads(content)
        
        for producto in productos:
            if producto['codigo'] == codigo:
                producto['descripcion'] = producto_actualizado.get('descripcion', producto['descripcion'])
                producto['precio'] = producto_actualizado.get('precio', producto['precio'])
                break
        else:
            return jsonify({'error': 'Producto no encontrado'}), 404
        
        json_productos = json.dumps(productos, indent=4)
        encoded_content = base64.b64encode(json_productos.encode('utf-8')).decode('utf-8')
        
        sha = data['sha']
        
        update_response = requests.put(
            api_url,
            headers={'Authorization': f'Bearer {token}'},
            json={
                'message': 'Actualizar producto',
                'content': encoded_content,
                'sha': sha
            }
        )
        
        if update_response.status_code == 200:
            return jsonify({'message': 'Producto actualizado correctamente'})
        else:
            return jsonify({'error': 'No se pudo actualizar el producto en GitHub'}), 500
    else:
        return jsonify({'error': 'No se pudieron obtener los productos'}), 400

# Ruta para agregar un nuevo producto (POST)
@app.route('/productos', methods=['POST'])
def agregar_producto():
    nuevo_producto = request.get_json()
    
    response = requests.get(api_url, headers={'Authorization': f'Bearer {token}'})
    if response.status_code == 200:
        data = response.json()
        content = base64.b64decode(data['content']).decode('utf-8')
        productos = json.loads(content)
        
        productos.append(nuevo_producto)
        
        json_productos = json.dumps(productos, indent=4)
        encoded_content = base64.b64encode(json_productos.encode('utf-8')).decode('utf-8')
        
        sha = data['sha']
        
        update_response = requests.put(
            api_url,
            headers={'Authorization': f'Bearer {token}'},
            json={
                'message': 'Agregar nuevo producto',
                'content': encoded_content,
                'sha': sha
            }
        )
        
        if update_response.status_code == 200:
            return jsonify({'message': 'Producto agregado correctamente'})
        else:
            return jsonify({'error': 'No se pudo agregar el producto en GitHub'}), 500
    else:
        return jsonify({'error': 'No se pudieron obtener los productos'}), 400

# Ruta para eliminar un producto (DELETE)
@app.route('/productos/<int:codigo>', methods=['DELETE'])
def eliminar_producto(codigo):
    response = requests.get(api_url, headers={'Authorization': f'Bearer {token}'})
    if response.status_code == 200:
        data = response.json()
        content = base64.b64decode(data['content']).decode('utf-8')
        productos = json.loads(content)
        
        productos = [producto for producto in productos if producto['codigo'] != codigo]
        
        json_productos = json.dumps(productos, indent=4)
        encoded_content = base64.b64encode(json_productos.encode('utf-8')).decode('utf-8')
        
        sha = data['sha']
        
        update_response = requests.put(
            api_url,
            headers={'Authorization': f'Bearer {token}'},
            json={
                'message': 'Eliminar producto',
                'content': encoded_content,
                'sha': sha
            }
        )
        
        if update_response.status_code == 200:
            return jsonify({'message': 'Producto eliminado correctamente'})
        else:
            return jsonify({'error': 'No se pudo eliminar el producto en GitHub'}), 500
    else:
        return jsonify({'error': 'No se pudieron obtener los productos'}), 400

if __name__ == '__main__':
    app.run(debug=True)
