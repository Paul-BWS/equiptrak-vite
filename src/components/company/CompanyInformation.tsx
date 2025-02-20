import { CompanyMap } from "@/components/maps/CompanyMap";
import { useAuth } from "@/contexts/AuthContext";

interface Company {
  id: string;
  company_name: string;
  telephone?: string;
  address?: string;
  city?: string;
  county?: string;
  postcode?: string;
  country?: string;
  industry?: string;
  website?: string;
}

interface CompanyInformationProps {
  company: Company;
}

export function CompanyInformation({ company }: CompanyInformationProps) {
  const { session } = useAuth();
  const isAdmin = session?.user?.email === "paul@basicwelding.co.uk" || 
                 session?.user?.email === "sales@basicwelding.co.uk";

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div className="space-y-4">
        <div>
          <label className="font-medium">Company Name</label>
          <p className="text-lg">{company?.company_name}</p>
        </div>
        <div>
          <label className="font-medium">Telephone</label>
          <p>{company?.telephone || 'Not provided'}</p>
        </div>
        <div>
          <label className="font-medium">Address</label>
          <p>{company?.address}</p>
          <p>{company?.city}, {company?.postcode}</p>
          <p>{company?.county}, {company?.country || 'United Kingdom'}</p>
        </div>
        {company?.industry && (
          <div>
            <label className="font-medium">Industry</label>
            <p>{company.industry}</p>
          </div>
        )}
        {company?.website && (
          <div>
            <label className="font-medium">Website</label>
            <p>
              <a 
                href={company.website} 
                target="_blank" 
                rel="noopener noreferrer"
                className="text-blue-600 hover:underline"
              >
                {company.website}
              </a>
            </p>
          </div>
        )}
      </div>
      
      <div className="h-[250px] bg-card rounded-lg">
        <CompanyMap
          address={company?.address || ""}
          city={company?.city || ""}
          postcode={company?.postcode || ""}
          country={company?.country || "United Kingdom"}
        />
      </div>
    </div>
  );
}