import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

const ENGINEERS = [
  "Paul Jones",
  "Danny Jennings",
  "Tommy Hannon",
  "Mark Allen",
  "Fernando Goulart",
  "Connor Hill",
  "Dominic TJ",
  "Mason Poulton",
  "Zack Collins"
];

interface ServiceEngineerSelectProps {
  defaultValue?: string;
  onChange: (value: string) => void;
}

export function ServiceEngineerSelect({ defaultValue, onChange }: ServiceEngineerSelectProps) {
  return (
    <Select defaultValue={defaultValue} onValueChange={onChange}>
      <SelectTrigger>
        <SelectValue placeholder="Select an engineer" />
      </SelectTrigger>
      <SelectContent>
        {ENGINEERS.map((engineer) => (
          <SelectItem key={engineer} value={engineer}>
            {engineer}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}