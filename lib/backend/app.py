from flask import Flask, request, jsonify
import youtube_dl

app = Flask(__name__)

@app.route('/extract_audio', methods=['POST'])
def extract_audio():
    data = request.get_json()
    url = data['url']
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': '/path/to/save/%(title)s.%(ext)s',
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        info_dict = ydl.extract_info(url, download=True)
        audio_file = ydl.prepare_filename(info_dict)
    
    return jsonify({'audio_file': audio_file})

if __name__ == '__main__':
    app.run(debug=True)
