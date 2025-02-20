import { Card, CardContent } from "@/components/ui/card";

interface ServiceStateViewProps {
  message: string;
  variant?: "default" | "destructive";
}

export function ServiceStateView({ message, variant = "default" }: ServiceStateViewProps) {
  return (
    <div className="bg-card rounded-lg p-6">
      <Card className="w-full">
        <CardContent className="p-6">
          <div className={`text-center ${variant === "destructive" ? "text-destructive" : ""}`}>
            {message}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}