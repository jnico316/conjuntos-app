-- schema.sql
-- Ejecuta este script en el SQL Editor de tu proyecto en Supabase

-- 1. Configuracion Global del Conjunto
CREATE TABLE public.config (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL DEFAULT 'Mi Conjunto Residencial',
    logo_url TEXT,
    primary_color VARCHAR(50) DEFAULT '#000000',
    announcement_sheet_url TEXT,
    debtors_sheet_url TEXT,
    monthly_budget NUMERIC DEFAULT 0,
    mora_interest_rate NUMERIC DEFAULT 1.5, -- Porcentaje, e.g. 1.5%
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Insertar una fila inicial para configuración
INSERT INTO public.config (name) VALUES ('Conjunto Residencial Demo');

-- 2. Bloques
CREATE TABLE public.blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL, -- Ej: 'Bloque 1', 'Torre A'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Unidades (Casas/Apartamentos)
CREATE TABLE public.units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    block_id UUID NOT NULL REFERENCES public.blocks(id) ON DELETE CASCADE,
    number VARCHAR(50) NOT NULL, -- Ej: 'Apto 101', '12'
    coefficient NUMERIC NOT NULL, -- Ej: 0.015 para 1.5% del total
    owner_name VARCHAR(255),
    resident_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Status ENUM para Facturas
CREATE TYPE invoice_status AS ENUM ('PENDING', 'OVERDUE', 'PAID');

-- 5. Facturas (Cuotas de administración mensuales)
CREATE TABLE public.invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
    period_month INT NOT NULL CHECK (period_month >= 1 AND period_month <= 12),
    period_year INT NOT NULL,
    base_amount NUMERIC NOT NULL DEFAULT 0,
    interest_amount NUMERIC NOT NULL DEFAULT 0,
    total_amount NUMERIC NOT NULL DEFAULT 0,
    status invoice_status DEFAULT 'PENDING',
    due_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Pagos
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES public.invoices(id) ON DELETE CASCADE,
    amount_paid NUMERIC NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    reference VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. RLS (Row Level Security)
-- Por ahora restringiremos todo a usuarios autenticados (los administradores)

ALTER TABLE public.config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- Políticas sencillas: Todo usuario autenticado tiene full access
CREATE POLICY "Full access for authenticated users on config" ON public.config FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Full access for authenticated users on blocks" ON public.blocks FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Full access for authenticated users on units" ON public.units FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Full access for authenticated users on invoices" ON public.invoices FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Full access for authenticated users on payments" ON public.payments FOR ALL USING (auth.role() = 'authenticated');
