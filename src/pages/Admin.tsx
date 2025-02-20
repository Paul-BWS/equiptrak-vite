import { CustomerList } from "@/components/CustomerList";
import { TestEmailButton } from "@/components/service/TestEmailButton";

export default function Admin() {
  return (
    <div className="space-y-6">
      <div className="bg-card p-6 rounded-lg border border-border/50">
        <h2 className="text-3xl font-bold tracking-tight">Companies</h2>
        <p className="text-muted-foreground">
          Manage customer accounts and equipment
        </p>
      </div>
      <div className="bg-card p-6 rounded-lg border border-border/50">
        <CustomerList />
      </div>
      <div className="bg-card p-6 rounded-lg border border-border/50">
        <h2 className="text-xl font-semibold mb-2">Email Testing</h2>
        <TestEmailButton />
      </div>
    </div>
  );
}