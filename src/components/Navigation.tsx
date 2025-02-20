import { Link } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "./ui/button";
import { Avatar, AvatarFallback } from "./ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "./ui/dropdown-menu";
import { Users, Settings, LogOut, Wrench, MessageSquare, UserCircle, ClipboardList } from "lucide-react";
import { toast } from "sonner";

export function Navigation() {
  const { session, signOut } = useAuth();
  
  // Check if user is admin
  const isAdmin = session?.user?.email === "paul@basicwelding.co.uk" || 
                 session?.user?.role === "admin";

  const handleSignOut = async () => {
    try {
      await signOut();
      toast.success("Signed out successfully");
    } catch (error) {
      console.error("Sign out error:", error);
      toast.error("Failed to sign out");
    }
  };

  // Get user initials for avatar
  const userInitials = session?.user?.email
    ? session.user.email.substring(0, 2).toUpperCase()
    : "U";

  // If not logged in, don't show navigation
  if (!session) return null;

  // For regular users, show simple header with logout
  if (!isAdmin) {
    return (
      <nav className="border-b bg-background">
        <div className="container mx-auto px-4">
          <div className="flex h-16 items-center justify-between">
            <div className="flex items-center gap-2">
              <Wrench className="h-6 w-6 text-primary" />
              <span className="text-xl font-bold text-primary">EquipTrack</span>
            </div>
            <Button variant="ghost" onClick={handleSignOut} className="gap-2">
              <LogOut className="h-4 w-4" />
              <span>Sign out</span>
            </Button>
          </div>
        </div>
      </nav>
    );
  }

  // Admin navigation with full features
  return (
    <nav className="border-b bg-background">
      <div className="container mx-auto px-4">
        <div className="flex h-16 items-center justify-between">
          {/* Logo and brand */}
          <div className="flex items-center gap-2">
            <Link 
              to="/admin" 
              className="flex items-center gap-2 text-xl font-bold text-primary hover:text-primary/90"
            >
              <Wrench className="h-6 w-6" />
              <span>EquipTrack</span>
            </Link>
          </div>

          {/* Main navigation - now visible on all devices */}
          <div className="flex items-center space-x-4 md:space-x-6">
            <Link 
              to="/admin"
              className="flex items-center gap-2 text-muted-foreground hover:text-primary"
            >
              <Users className="h-5 w-5" />
              <span className="hidden md:inline">Companies</span>
            </Link>
            <Link 
              to="/admin/equipment"
              className="flex items-center gap-2 text-muted-foreground hover:text-primary"
            >
              <ClipboardList className="h-5 w-5" />
              <span className="hidden md:inline">Equipment</span>
            </Link>
            <Link 
              to="/admin/chat"
              className="flex items-center gap-2 text-muted-foreground hover:text-primary"
            >
              <MessageSquare className="h-5 w-5" />
              <span className="hidden md:inline">Chat</span>
            </Link>
            <Link 
              to="/admin/personnel"
              className="flex items-center gap-2 text-muted-foreground hover:text-primary"
            >
              <UserCircle className="h-5 w-5" />
              <span className="hidden md:inline">Personnel</span>
            </Link>
          </div>

          {/* User menu */}
          <div className="flex items-center">
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" className="relative h-8 w-8 rounded-full">
                  <Avatar className="h-8 w-8">
                    <AvatarFallback>{userInitials}</AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuLabel>
                  {session.user.email}
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem asChild>
                  <Link to="/admin/settings" className="flex items-center">
                    <Settings className="mr-2 h-4 w-4" />
                    <span>Settings</span>
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem onClick={handleSignOut}>
                  <LogOut className="mr-2 h-4 w-4" />
                  <span>Sign out</span>
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
    </nav>
  );
}