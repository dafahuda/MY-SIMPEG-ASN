import { redirect } from 'next/navigation'

// Temporary redirect — will be replaced by dashboard layout
export default function ProtectedPage() {
  redirect('/dashboard')
}
