import React, { useState } from 'react';
import './App.css';

function App() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [uploadStatus, setUploadStatus] = useState('');
  const [result, setResult] = useState(null);

  // Dosya seçildiğinde çağrılır
  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  // CSV dosyasını yükler
  const handleUpload = async () => {
    if (!selectedFile) {
      setUploadStatus('Lütfen bir CSV dosyası seçin.');
      return;
    }

    const formData = new FormData();
    formData.append('file', selectedFile);

    try {
      // API'ye dosya yükleme isteği
      const response = await fetch('https://your-api-gateway-url.com/analyze', {
        method: 'POST',
        body: formData,
      });

      if (response.ok) {
        setUploadStatus('Dosya başarıyla yüklendi.');
      } else {
        setUploadStatus('Yükleme sırasında bir hata oluştu.');
      }
    } catch (error) {
      setUploadStatus('Yükleme başarısız oldu.');
    }
  };

  // Lambda fonksiyonundan sonucu alma
  const handleResult = async () => {
    try {
      const response = await fetch('https://your-api-gateway-url.com/analyze');
      const data = await response.json();
      setResult(data);
    } catch (error) {
      console.error('Sonuçları getirme sırasında bir hata oluştu:', error);
    }
  };

  return (
    <div className="App">
      <h1>Football Wonderkid Potential Calculator by CanYalcin</h1>

      <div className="file-upload">
        <input type="file" onChange={handleFileChange} />
        {selectedFile && <p>Seçilen dosya: {selectedFile.name}</p>}
        <button onClick={handleUpload}>Upload</button>
      </div>

      {uploadStatus && <p>{uploadStatus}</p>}

      <button onClick={handleResult}>Result</button>

      {result && (
        <div className="result">
          <h2>Sonuçlar</h2>
          <pre>{JSON.stringify(result, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
