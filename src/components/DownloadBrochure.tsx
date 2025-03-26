import React, { useState } from 'react';
import { Download } from 'lucide-react';

interface DownloadBrochureProps {
  category: string;
}

const DownloadBrochure: React.FC<DownloadBrochureProps> = ({ category }) => {
  const [isButtonAnimating, setIsButtonAnimating] = useState(false);

  const handleDownload = () => {
    setIsButtonAnimating(true);
    // Replace with your actual brochure URL
    window.open(`/brochures/${category.toLowerCase().replace(' ', '-')}.pdf`, '_blank');
    setTimeout(() => setIsButtonAnimating(false), 1000);
  };

  return (
    <button
      onClick={handleDownload}
      className={`group relative inline-flex items-center gap-2 px-6 py-3 bg-orange-500 text-black font-medium rounded-lg overflow-hidden transition-all duration-300 hover:bg-orange-400 ${
        isButtonAnimating ? 'animate-pulse' : ''
      }`}
    >
      <span className="relative z-10 flex items-center gap-2">
        <Download 
          className={`w-5 h-5 transition-transform duration-300 ${
            isButtonAnimating ? 'translate-y-1' : 'group-hover:translate-y-1'
          }`}
        />
        Download {category} Brochure
      </span>
      <div className="absolute inset-0 bg-orange-400 transform origin-left scale-x-0 transition-transform duration-300 group-hover:scale-x-100" />
    </button>
  );
};

export default DownloadBrochure;