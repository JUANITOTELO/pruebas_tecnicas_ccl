document.addEventListener('DOMContentLoaded', () => {
    let uri = 'http://192.168.0.9:5000'
    // Login form submission
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            fetch(
                uri+'/api/Auth/Login',
                {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        Email: document.getElementById('Email').value,
                        Password: document.getElementById('Password').value,
                    }),
                }
            ).then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Login failed');
            }).then(data => {
                // Store token in local storage
                localStorage.setItem('jwtToken', data);
                // Redirect to dashboard
                window.location.href = '/inventory_dashboard.html';
            }).catch(error => {
                alert('Login failed');
                console.error(error);
            });
        });
    }

    // Logout
    const logoutButton = document.getElementById('logoutButton');
    if (logoutButton) {
        logoutButton.addEventListener('click', () => {
            localStorage.removeItem('jwtToken');
            window.location.href = '/index.html';
        });
    }

    // Product dashboard
    const productDashboard = document.getElementById('productDashboard');
    if (productDashboard) {
        // Fetch products
        fetch(
            uri+'/api/productos',
            {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + localStorage.getItem('jwtToken'),
                },
            }
        ).then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Failed to fetch products');
        }).then(data => {
            data.forEach(product => {
                const productRow = document.createElement('tr');
                productRow.innerHTML = `
                    <td><input type="checkbox" name="product" value="${product.id}"></td>
                    <td>${product.id}</td>
                    <td>${product.nombre}</td>
                    <td>${product.precio}</td>
                    <td>${product.descripcion}</td>
                `;
                productDashboard.getElementsByTagName('tbody')[0].appendChild(productRow);
            });
        }).catch(error => {
            console.error(error);
        });

        // Seleccionar/Deseleccionar todos los checkboxes
        document.getElementById('selectAll').addEventListener('change', function () {
            const checkboxes = document.querySelectorAll('#productDashboard tbody input[type="checkbox"]');
            checkboxes.forEach(checkbox => checkbox.checked = this.checked);
        });

        // Función para eliminar productos seleccionados
        function deleteSelectedProducts() {
            const selectedCheckboxes = document.querySelectorAll('#productDashboard tbody input[type="checkbox"]:checked');
            selectedCheckboxes.forEach(checkbox => {
                const row = checkbox.closest('tr');
                row.parentNode.removeChild(row);
                fetch(
                    uri+`/api/productos/${checkbox.value}`,
                    {
                        method: 'DELETE',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('jwtToken'),
                        },
                        body: JSON.stringify({
                            Id: checkbox.value
                        }),
                    }
                ).then(response => {
                    if (response.ok) {
                        console.log('Product deleted successfully');
                        return;
                    }
                    throw new Error('Failed to delete product');
                }).catch(error => {
                    console.error(error);
                });
            });
        }

        // Eliminar productos seleccionados
        document.getElementById('deleteSelected').addEventListener('click', deleteSelectedProducts);
                    
        // Add product form submission
        const addProductForm = document.getElementById('addProductForm');
        addProductForm.addEventListener('submit', (e) => {
            e.preventDefault();
            fetch(
                uri+'/api/productos',
                {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + localStorage.getItem('jwtToken')
                    },
                    body: JSON.stringify({
                        Nombre: addProductForm.querySelector('#name').value,
                        Precio: addProductForm.querySelector('#price').value,
                        Descripcion: addProductForm.querySelector('#description').value
                    }),
                }
            ).then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Failed to add product');
            }).then(data => {
                // Update the table
                const productRow = document.createElement('tr');
                productRow.innerHTML = `
                <td><input type="checkbox" name="product" value="${data.id}"></td>
                <td>${data.id}</td>
                <td>${data.nombre}</td>
                <td>${data.precio}</td>
                <td>${data.descripcion}</td>
            `;
                productDashboard.getElementsByTagName('tbody')[0].appendChild(productRow);
                // Clear form
                addProductForm.querySelector('#name').value = '';
                addProductForm.querySelector('#price').value = '';
                addProductForm.querySelector('#description').value = '';
                // Close modal
                document.getElementById('closeAddProductModal').click();
            }).catch(error => {
                console.error(error);
            });
        });
    }

    // Inventory dashboard
    const inventoryDashboard = document.getElementById('inventoryDashboard');
    if (inventoryDashboard) {
        let inventory = [];
        let products = [];
        // Fetch inventory and products
        fetch(
            uri+'/api/inventario',
            {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    Authorization: 'Bearer ' + localStorage.getItem('jwtToken')
                },
            }).then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Failed to fetch inventory');
            }).then(async data => {
                inventory = data;
                return fetch(
                    uri+'/api/productos',
                    {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('jwtToken'),
                        },
                    }
                ).then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Failed to fetch products');
                }).then(data => {
                    products = data;
                }).then(() => {
                    inventory.forEach(inventoryItem => {
                        const product = products.find(product => product.id === inventoryItem.id_producto);
                        const inventoryRow = document.createElement('tr');
                        inventoryRow.innerHTML = `
                        <td><input type="checkbox" name="inventory" value="${product.id}"></td>
                        <td>${product.id}</td>
                        <td>${product.nombre}</td>
                        <td>${inventoryItem.cantidad}</td>
                        <td>${product.precio}</td>
                        <td>${inventoryItem.last_updated}</td>
                        <td>${inventoryItem.cantidad * product.precio}</td>
                    `;
                        inventoryDashboard.getElementsByTagName('tbody')[0].appendChild(inventoryRow);
                    });
                    let total = inventory.length;
                    let cardTotal = document.getElementById('totalProducts');
                    cardTotal.innerHTML = total;
                    
                }).catch(error => {
                    console.error(error);
                });
            });
            
        // Seleccionar/Deseleccionar todos los checkboxes
        document.getElementById('selectAll').addEventListener('change', function () {
            const checkboxes = document.querySelectorAll('#inventoryDashboard tbody input[type="checkbox"]');
            checkboxes.forEach(checkbox => checkbox.checked = this.checked);
        });

        // Función para eliminar productos seleccionados
        function deleteSelectedInventory() {
            const selectedCheckboxes = document.querySelectorAll('#inventoryDashboard tbody input[type="checkbox"]:checked');
            selectedCheckboxes.forEach(checkbox => {
                
                fetch(
                    uri+`/api/inventario/${checkbox.value}`,
                    {
                        method: 'DELETE',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('jwtToken')
                        },
                        body: JSON.stringify({
                            Id: checkbox.value
                        }),
                    }).then(response => {
                        if (response.ok) {
                            window.location.reload();
                            return;
                        }
                        throw new Error('Failed to delete inventory item');
                    }).catch(error => {
                        alert('Error al eliminar el producto\n'+error);
                    });
                });
        }

        // Eliminar productos seleccionados
        document.getElementById('deleteSelected').addEventListener('click', deleteSelectedInventory);
        
        // Agregar productos al select del formulario
        fetch(
            uri+'/api/productos',
            {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + localStorage.getItem('jwtToken'),
                },
            }
        ).then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Failed to fetch products');
        }).then(data => {
            data.forEach(product => {
                const productOption = document.createElement('option');
                productOption.value = product.id;
                productOption.textContent = product.nombre;
                document.getElementById('productID').appendChild(productOption);
            });
        }).catch(error => {
            console.error(error);
        });

        // Add product to inventory form submission
        const addProductToInventoryForm = document.getElementById('addProductToInventoryForm');
        addProductToInventoryForm.addEventListener('submit', (e) => {
            e.preventDefault();
            fetch(
                uri+'/api/inventario',
                {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + localStorage.getItem('jwtToken')
                    },
                    body: JSON.stringify({
                        Id_producto: addProductToInventoryForm.querySelector('#productID').value,
                        Cantidad: addProductToInventoryForm.querySelector('#quantity').value
                    }),
                }).then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Failed to add product to inventory');
                }).then(data => {
                    // Clear form
                    addProductToInventoryForm.querySelector('#productID').value = '';
                    addProductToInventoryForm.querySelector('#quantity').value = '';
                    // Close modal
                    document.getElementById('closeAddProductToInventoryModal').click();

                    window.location.reload();
                
                }).catch(error => {
                    console.error(error);
                });
            });

    }

});
