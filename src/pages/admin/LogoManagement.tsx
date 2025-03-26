import React, { useState, useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import { Link } from 'react-router-dom';
import { ArrowLeft, Upload, Loader2 } from 'lucide-react';

const LogoManagement = () => {
  const [logo, setLogo] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);

  const onDrop = useCallback((acceptedFiles: File[]) => {
    const file = acceptedFiles[0];
    if (file) {
      setUploading(true);
      const reader = new FileReader();
      reader.onload = () => {
        const base64String = reader.result as string;
        localStorage.setItem('siteLogo', base64String);
        setLogo(base64String);
        setUploading(false);
      };
      reader.readAsDataURL(file);
    }
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.png', '.jpg', '.jpeg', '.svg']
    },
    maxFiles: 1
  });

  return (
    <div className="p-6 mt-16">
      <div className="max-w-7xl mx-auto">
        <div className="flex items-center mb-8">
          <Link to="/admin" className="mr-4">
            <ArrowLeft className="w-6 h-6 text-orange-500" />
          </Link>
          <h1 className="text-3xl font-bold">Logo Management</h1>
        </div>

        <div className="bg-gray-800 rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">Upload Logo</h2>
          
          <div
            {...getRootProps()}
            className={`border-2 border-dashed rounded-lg p-8 text-center transition-colors duration-300 ${
              isDragActive ? 'border-orange-500 bg-orange-500/10' : 'border-gray-600 hover:border-orange-500'
            }`}
          >
            <input {...getInputProps()} />
            {uploading ? (
              <div className="flex flex-col items-center">
                <Loader2 className="w-12 h-12 text-orange-500 animate-spin mb-4" />
                <p className="text-gray-400">Uploading logo...</p>
              </div>
            ) : (
              <div className="flex flex-col items-center">
                <Upload className="w-12 h-12 text-gray-400 mb-4" />
                <p className="text-gray-400">
                  {isDragActive
                    ? 'Drop the logo here...'
                    : 'Drag & drop your logo here, or click to select file'}
                </p>
              </div>
            )}
          </div>

          {logo && (
            <div className="mt-8">
              <h3 className="text-lg font-semibold mb-4">Preview</h3>
              <div className="bg-white p-4 rounded-lg inline-block">
                <img src={logo} alt="New logo" className="max-h-20" />
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default LogoManagement;