import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export default async function LoginPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (user) {
    redirect('/')
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-100">
      <div className="w-full max-w-md p-8 bg-white rounded-lg shadow-md">
        <h1 className="text-2xl font-bold mb-6 text-center">Acceso Administrador</h1>
        <p className="text-center text-sm text-gray-500 mb-4">Por favor, configure el formulario en este archivo.</p>
        {/* Aquí irá el formulario de Server Action en los próximos pasos */}
      </div>
    </div>
  )
}
