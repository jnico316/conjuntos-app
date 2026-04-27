export default function DashboardPage() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-6">Panel Principal</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="p-6 bg-white shadow rounded-lg border border-gray-100">
          <h2 className="font-semibold text-gray-700">Total Unidades</h2>
          <p className="text-3xl font-bold text-gray-900 mt-2">--</p>
        </div>
        <div className="p-6 bg-white shadow rounded-lg border border-gray-100">
          <h2 className="font-semibold text-gray-700">Morosos</h2>
          <p className="text-3xl font-bold text-red-600 mt-2">--</p>
        </div>
        <div className="p-6 bg-white shadow rounded-lg border border-gray-100">
          <h2 className="font-semibold text-gray-700">Recaudado este mes</h2>
          <p className="text-3xl font-bold text-green-600 mt-2">$0</p>
        </div>
      </div>
    </div>
  )
}
