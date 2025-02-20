import { useState } from "react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "./ui/use-toast";
import { useAdminCheck } from "@/hooks/useAdminCheck";
import { CustomerListHeader } from "./customers/CustomerListHeader";
import { CustomerSearchBar } from "./customers/CustomerSearchBar";
import { CustomerTable } from "./customers/CustomerTable";
import { CustomerDialogs } from "./customers/CustomerDialogs";

interface Company {
  id: string;
  company_name: string;
  address?: string;
  city?: string;
  county?: string;
  postcode?: string;
  country?: string;
  created_at: string;
  updated_at: string;
}

export function CustomerList() {
  const [searchQuery, setSearchQuery] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [companyToDelete, setCompanyToDelete] = useState<string | null>(null);
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const { data: isAdmin, error: adminError } = useAdminCheck();

  // Fetch companies if user is admin
  const { data: companies, isLoading, error: fetchError } = useQuery({
    queryKey: ["companies"],
    queryFn: async () => {
      try {
        // First, ensure we have at least one company
        const { data: existingCompanies, error: checkError } = await supabase
          .from("companies")
          .select("id")
          .limit(1);

        if (checkError) {
          console.error("Error checking companies:", checkError);
          throw checkError;
        }

        // If no companies exist, create a test company
        if (!existingCompanies || existingCompanies.length === 0) {
          const { error: insertError } = await supabase
            .from("companies")
            .insert([
              {
                company_name: "Basic Welding Supplies Ltd",
                address: "123 Main Street",
                city: "Manchester",
                county: "Greater Manchester",
                postcode: "M1 1AA"
              }
            ]);

          if (insertError) {
            console.error("Error creating test company:", insertError);
            throw insertError;
          }
        }

        // Now fetch all companies
        const { data, error } = await supabase
          .from("companies")
          .select()
          .order('company_name');

        if (error) {
          console.error("Error fetching companies:", error);
          throw error;
        }

        return data || [];
      } catch (error: any) {
        console.error("Unexpected error in company fetch:", error);
        toast({
          variant: "destructive",
          title: "Error fetching companies",
          description: error.message,
        });
        return [];
      }
    },
    enabled: !!isAdmin
  });

  const handleDeleteCompany = async (companyId: string) => {
    try {
      const { error } = await supabase
        .from("companies")
        .delete()
        .eq("id", companyId);

      if (error) throw error;

      toast({
        title: "Success",
        description: "Company deleted successfully",
      });
      
      queryClient.invalidateQueries({ queryKey: ["companies"] });
      setCompanyToDelete(null);
    } catch (error: any) {
      console.error("Delete error:", error);
      toast({
        variant: "destructive",
        title: "Error deleting company",
        description: error.message,
      });
    }
  };

  const filteredCompanies = companies?.filter((company) =>
    company.company_name?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  if (adminError) {
    console.error("Admin check error:", adminError);
    return (
      <div className="p-4 text-red-500">
        Error checking admin status: {adminError.message}
      </div>
    );
  }

  if (isAdmin === false) {
    return (
      <div className="p-4 text-red-500">
        Access denied: You must be an admin to view this page.
      </div>
    );
  }

  if (fetchError) {
    return (
      <div className="p-4 text-red-500">
        Error loading companies: {fetchError.message}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <CustomerListHeader onAddClick={() => setIsDialogOpen(true)} />
      
      <CustomerSearchBar 
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      <CustomerTable 
        companies={filteredCompanies || []}
        isLoading={isLoading}
        onDeleteCompany={setCompanyToDelete}
      />

      <CustomerDialogs 
        isAddDialogOpen={isDialogOpen}
        companyToDelete={companyToDelete}
        onAddDialogChange={setIsDialogOpen}
        onDeleteDialogChange={setCompanyToDelete}
        onDeleteConfirm={handleDeleteCompany}
      />
    </div>
  );
}