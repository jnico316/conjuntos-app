'use client'

export default function ErrorBoundary({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div className="p-8 text-red-500">
      <h2 className="text-2xl font-bold mb-4">Algo salió mal</h2>
      <pre className="bg-red-50 p-4 rounded text-sm overflow-auto mb-4 border border-red-200">
        {error.message}
      </pre>
      {error.stack && (
        <pre className="bg-gray-50 text-gray-800 p-4 rounded text-xs overflow-auto">
          {error.stack}
        </pre>
      )}
      <button
        onClick={() => reset()}
        className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
      >
        Intentar de nuevo
      </button>
    </div>
  )
}
