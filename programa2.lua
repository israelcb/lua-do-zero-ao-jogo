ultimaCopa = {
	ano = 2002,
	sede = "Japão de Coréia do Sul",
	jogadores = {"Cafu", "Ronaldo"},
	imprime = function(self)
		for k,v in ipairs(self.jogadores) do
			print(k, v)
		end
	end,
}

print(ultimaCopa["ano"])
print(ultimaCopa.ano)

ultimaCopa.capitao = "Cafu"
print(ultimaCopa.capitao)

print(ultimaCopa.jogadores[1])
print(ultimaCopa.jogadores[2])

table.insert(ultimaCopa.jogadores, "Rivaldo")
table.insert(ultimaCopa.jogadores, "Zico")
table.remove(ultimaCopa.jogadores, 4)

ultimaCopa.imprime(ultimaCopa)
ultimaCopa:imprime()