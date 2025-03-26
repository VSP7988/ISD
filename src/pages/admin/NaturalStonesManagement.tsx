import React, { useState, useCallback, useEffect } from 'react';
import { useDropzone } from 'react-dropzone';
import { Link } from 'react-router-dom';
import { ArrowLeft, Upload, Loader2, Trash2, AlertCircle } from 'lucide-react';
import imageCompression from 'browser-image-compression';
import { supabase } from '../../lib/supabase';

interface GalleryImage {
  id: string;
  title: string;
  image_url: string;
  order: number;
}

const MAX_FILE_SIZE = 100 * 1024 * 1024; // 100MB

const NaturalStonesManagement = () => {
  const [images, setImages] = useState<GalleryImage[]>([]);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadImages();
  }, []);

  const loadImages = async () => {
    try {
      const { data, error } = await supabase
        .from('natural_stones_gallery')
        .select('*')
        .order('order');

      if (error) throw error;
      setImages(data || []);
    } catch (error) {
      console.error('Error loading images:', error);
      setError('Failed to load images');
    } finally {
      setLoading(false);
    }
  };

  const compressImage = async (file: File) => {
    const options = {
      maxSizeMB: 5,
      maxWidthOrHeight: 2560,
      useWebWorker: true
    };

    try {
      return await imageCompression(file, options);
    } catch (error) {
      console.error('Error compressing image:', error);
      throw new Error('Failed to compress image');
    }
  };

  const uploadToStorage = async (file: File) => {
    try {
      const fileExt = file.name.split('.').pop();
      const fileName = `${Math.random()}.${fileExt}`;
      const filePath = `${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('natural-stones')
        .upload(filePath, file);

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('natural-stones')
        .getPublicUrl(filePath);

      return publicUrl;
    } catch (error) {
      console.error('Error uploading to storage:', error);
      throw new Error('Failed to upload image to storage');
    }
  };

  const onDrop = useCallback(async (acceptedFiles: File[]) => {
    setError(null);
    setUploading(true);

    try {
      const uploadPromises = acceptedFiles.map(async (file, index) => {
        if (file.size > MAX_FILE_SIZE) {
          throw new Error(`File "${file.name}" exceeds 100MB limit`);
        }

        const compressedFile = await compressImage(file);
        const imageUrl = await uploadToStorage(compressedFile);
        
        return {
          title: file.name.replace(/\.[^/.]+$/, ""),
          image_url: imageUrl,
          order: images.length + index
        };
      });

      const newImages = await Promise.all(uploadPromises);

      const { data, error } = await supabase
        .from('natural_stones_gallery')
        .insert(newImages)
        .select();

      if (error) throw error;

      setImages(prev => [...prev, ...(data || [])]);
      setError(null);
    } catch (error) {
      console.error('Error uploading images:', error);
      setError(error instanceof Error ? error.message : 'Failed to upload images');
    } finally {
      setUploading(false);
    }
  }, [images]);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.png', '.jpg', '.jpeg', '.webp']
    },
    disabled: uploading,
    multiple: true,
    maxSize: MAX_FILE_SIZE
  });

  const removeImage = async (id: string) => {
    try {
      // First, get the image URL to extract the file name
      const image = images.find(img => img.id === id);
      if (image) {
        const fileName = image.image_url.split('/').pop();
        if (fileName) {
          // Delete from storage
          await supabase.storage
            .from('natural-stones')
            .remove([fileName]);
        }
      }

      // Delete from database
      const { error } = await supabase
        .from('natural_stones_gallery')
        .delete()
        .eq('id', id);

      if (error) throw error;

      setImages(prev => prev.filter(img => img.id !== id));
      setError(null);
    } catch (error) {
      console.error('Error removing image:', error);
      setError('Failed to remove image');
    }
  };

  const updateImageTitle = async (id: string, newTitle: string) => {
    try {
      const { error } = await supabase
        .from('natural_stones_gallery')
        .update({ title: newTitle })
        .eq('id', id);

      if (error) throw error;

      setImages(prev => prev.map(img => 
        img.id === id ? { ...img, title: newTitle } : img
      ));
      setError(null);
    } catch (error) {
      console.error('Error updating title:', error);
      setError('Failed to update title');
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <Loader2 className="w-8 h-8 animate-spin text-orange-500" />
      </div>
    );
  }

  return (
    <div className="p-6 mt-16">
      <div className="max-w-7xl mx-auto">
        <div className="flex items-center mb-8">
          <Link to="/admin" className="mr-4">
            <ArrowLeft className="w-6 h-6 text-orange-500" />
          </Link>
          <h1 className="text-3xl font-bold">Natural Stones Management</h1>
        </div>

        {error && (
          <div className="mb-6 bg-red-500/10 border border-red-500 text-red-500 px-4 py-3 rounded-lg flex items-center">
            <AlertCircle className="w-5 h-5 mr-2" />
            {error}
          </div>
        )}

        <div className="bg-gray-800 rounded-lg p-6 mb-8">
          <h2 className="text-xl font-semibold mb-6">Upload Gallery Images</h2>
          
          <div
            {...getRootProps()}
            className={`border-2 border-dashed rounded-lg p-8 text-center transition-colors duration-300 ${
              uploading
                ? 'border-gray-600 bg-gray-700 cursor-not-allowed' 
                : isDragActive 
                  ? 'border-orange-500 bg-orange-500/10' 
                  : 'border-gray-600 hover:border-orange-500'
            }`}
          >
            <input {...getInputProps()} />
            {uploading ? (
              <div className="flex flex-col items-center">
                <Loader2 className="w-12 h-12 text-orange-500 animate-spin mb-4" />
                <p className="text-gray-400">Uploading images...</p>
              </div>
            ) : (
              <div className="flex flex-col items-center">
                <Upload className="w-12 h-12 text-gray-400 mb-4" />
                <p className="text-gray-400">
                  {isDragActive
                    ? 'Drop the images here...'
                    : 'Drag & drop images here, or click to select'}
                </p>
                <p className="text-sm text-gray-500 mt-2">
                  Maximum file size: 100MB per image
                </p>
              </div>
            )}
          </div>
        </div>

        <div className="bg-gray-800 rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-6">Gallery Images</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {images.map((image) => (
              <div key={image.id} className="bg-gray-700 rounded-lg overflow-hidden">
                <div className="aspect-square">
                  <img
                    src={image.image_url}
                    alt={image.title}
                    className="w-full h-full object-cover"
                  />
                </div>
                <div className="p-4">
                  <input
                    type="text"
                    value={image.title}
                    onChange={(e) => updateImageTitle(image.id, e.target.value)}
                    className="w-full px-3 py-2 bg-gray-600 border border-gray-500 rounded-lg focus:outline-none focus:border-orange-500 text-white mb-3"
                  />
                  <button
                    onClick={() => removeImage(image.id)}
                    className="flex items-center text-red-500 hover:text-red-400 transition-colors duration-300"
                  >
                    <Trash2 className="w-4 h-4 mr-2" />
                    Remove
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default NaturalStonesManagement;