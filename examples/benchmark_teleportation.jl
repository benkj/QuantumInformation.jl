using QI
using LinearAlgebra
using Statistics

steps = 100
haar = HaarKet(2)
ψ = (ket(0, 4) + ket(3, 4))/sqrt(2)
post = [PostSelectionMeasurement(proj(ket(i, 4)) ⊗ 𝕀(2)) for i=0:3]
rots = [UnitaryChannel(𝕀(2)), UnitaryChannel(sx), UnitaryChannel(sz), UnitaryChannel(sx*sz)]
had = UnitaryChannel{Matrix{ComplexF64}}(hadamard(2))
cnot = UnitaryChannel{Matrix{ComplexF64}}([1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0])
r = zeros(steps, length(γs), 4)
for (k, γ) in enumerate(γs)
    for i = 1:steps
        ϕ = rand(haar)
        ξ = ϕ ⊗ ψ
        ρ = ((had ⊗ IdentityChannel(4))∘(cnot ⊗ IdentityChannel(2))∘(IdentityChannel(4) ⊗ Φ(γ)))(ξ)
        for j=1:4
            σ = rots[j](ptrace(post[j](ρ), [2, 2, 2], [1, 2]))
            r[i, k, j] = fidelity(ϕ, σ/tr(σ))
        end
    end
end
mean(r, dims=1)
