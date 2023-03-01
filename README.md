
Hola, Buenas Tardes. Aqui mi experiencia de como resolver el problema.

1.- Crear la Base de datos En Postgrest con lo solicitado e ingresar datos en el cual estan en SQL_PRODUCT.txt

2.- Configurar database.yml con las credenciales de mi base de datos para levantar el servidor.

3.-Crear el modelo y controllador de product y luego su endpoint.

4.- en el modelo agregue un self.table_name = "product" para relacionarlo a la tabla de la base de datos creada y un scope el cual me permite filtrar por branch y description con la validacion de search.length >= 3 que en el pdf lo solicitaba al hacer una busqueda.

5.- en el controlador se agrego un metodo index el cual puede recibir query params como params[:search], donde defino search_param = params[:search].to_s.strip para convertirlo a string y con .strip eliminar los espacios en blanco al principio y al final de la cadena.

6.- Luego en if search_param.match?(/^\d+$/) && search_param.to_i > 0 se valida si la cadena ingresada es solo numeros y que se mayor a 0 el cual despues se usara para buscar el id de producto donde:

 begin
          @product = Product.find(params[:search])
          @product.price /= 2 if @product.branch.downcase.gsub(/[^a-z]/i, '').reverse == @product.branch.downcase.gsub(/[^a-z]/i, '')
          return render :json => @product, status: 200
        rescue ActiveRecord::RecordNotFound
          @products = Product.searchs(params[:search])
        end

se realiza un begin para que primero si se cumple encontrar el producto con el id, si se da el caso se debe verificar si el producto es palíndromo y aplicar el descuento del 50% dpmde se actualiza el producto pero solo para la consulta, en caso de no serlo el precio se mantiene y se retorna un json con los datos.

En caso de no encontrar el producto por el id, en el rescue se filtrara por el scope para verificar si en el query params existe el valor tanto en branch y en descripcion, el begin y rescue fue agregado por que al no encontrar coincidencias la app seguia el proceso de @product y arrojaba error en el array de @products.

7.- En caso de que el query params no sea numerico se realizara la busqueda por branch y descripcion si es que cumple con el length de >=3,
si no se presenta query params solo se traera todos los Products en la base de datos.

8.- Si se da el caso de no encontrar productos por id con el find ya que ese solo trae un solo registro que es para @product, se debe agregar un .each para @products el cual verifique todos los productos palíndromos para realizar el descuento solicitado y devolver el array en un json.

9.- crear el endpoint para ser consumido en el front.

10.- crear en un archivo de react App.js un input el cual consumira el endpoint con axios para traer los datos y si agrega un valor al input se filtraran los datos correspondientes al valor agregado.

11.- en el caso de React me verifique que tube un problema de Cors al tratar de consumir el endpoint de ruby , ya que en postman funcionaba sin problemas, lo cual en cors.rb se agrego Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :delete]
    end
  end
para realizar la prueba la cual funciono correctamente.

12. Finalmente subir los archivos al repositorio de github.