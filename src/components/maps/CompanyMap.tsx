import { GoogleMap, MarkerF } from "@react-google-maps/api";
import { useEffect, useState } from "react";
import { useMaps } from "@/contexts/MapsContext";

interface CompanyMapProps {
  address: string;
  city: string;
  postcode: string;
  country: string;
}

// Memoize the script options
const mapOptions = {
  zoomControl: true,
  streetViewControl: false,
  mapTypeControl: false,
  fullscreenControl: false,
  zoom: 10,
  minZoom: 6,
  maxZoom: 18,
};

export function CompanyMap({ address, city, postcode, country }: CompanyMapProps) {
  const [coordinates, setCoordinates] = useState<{ lat: number; lng: number }>({ lat: 51.5074, lng: -0.1278 }); // Default to London
  const [isLoading, setIsLoading] = useState(true);
  const [geocodeError, setGeocodeError] = useState<string | null>(null);
  
  const { isLoaded, loadError, isInitialized } = useMaps();

  console.log("CompanyMap render state:", {
    address,
    city,
    postcode,
    isLoaded,
    isInitialized,
    hasError: !!loadError
  });

  // Handle geocoding
  useEffect(() => {
    if (!isLoaded || !address) return;

    try {
      setGeocodeError(null);
      const geocoder = new google.maps.Geocoder();
      const fullAddress = `${address}, ${city} ${postcode}`;

      console.log("Geocoding address:", fullAddress);

      geocoder.geocode(
        { address: fullAddress, region: 'GB' },
        (results, status) => {
          if (status === "OK" && results?.[0]) {
            const location = results[0].geometry.location;
            setCoordinates({
              lat: location.lat(),
              lng: location.lng()
            });
            console.log("Geocoding successful:", {
              lat: location.lat(),
              lng: location.lng()
            });
          } else {
            console.error("Geocoding failed:", status);
            setGeocodeError(`Could not locate address: ${status}`);
          }
          setIsLoading(false);
        }
      );
    } catch (error) {
      console.error("Error in geocoding:", error);
      setGeocodeError("Failed to geocode address");
      setIsLoading(false);
    }
  }, [isLoaded, address, city, postcode]);

  if (!isInitialized) {
    console.log("Map not initialized yet");
    return (
      <div className="h-full w-full bg-muted flex flex-col items-center justify-center">
        <div>Initializing maps...</div>
      </div>
    );
  }

  if (loadError) {
    console.error("Map load error:", loadError);
    return (
      <div className="h-full w-full bg-muted flex flex-col items-center justify-center text-destructive">
        <div>Error loading map</div>
        <div className="text-sm mt-2 text-muted-foreground">{loadError.message}</div>
      </div>
    );
  }

  if (!isLoaded) {
    console.log("Map still loading");
    return (
      <div className="h-full w-full bg-muted flex flex-col items-center justify-center">
        <div>Loading map...</div>
      </div>
    );
  }

  if (geocodeError) {
    console.error("Geocoding error:", geocodeError);
    return (
      <div className="h-full w-full bg-muted flex flex-col items-center justify-center text-destructive">
        <div>{geocodeError}</div>
      </div>
    );
  }

  console.log("Rendering map with coordinates:", coordinates);
  return (
    <div className="h-full w-full rounded-lg overflow-hidden border border-border">
      <GoogleMap
        zoom={10}
        center={coordinates}
        mapContainerClassName="w-full h-full"
        options={mapOptions}
      >
        <MarkerF position={coordinates} />
      </GoogleMap>
    </div>
  );
}