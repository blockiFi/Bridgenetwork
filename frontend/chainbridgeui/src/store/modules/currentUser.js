import axios from 'axios'
import Moralis from './Moralis'
const state = {
    
    userAuthenticated: false,
    user : {} ,
    loggedIn: false,
    updateImageDialog : false
};
const getters = {};
const actions ={
    setUser({commit} , user){
        commit("setActiveUser" , user);
    },
    updateName({commit} , name){
        return new Promise((resolve , reject) => {
            axios.post('/api/profile/updatename' ,  { 'name' : name}).then( response => {
             if(response.data.code == '200'){
                commit('setUser' ,  response.data.user);
                resolve(response.data.msg);
             } else{
                 reject(response.data.error);
             }  
            }).catch( error => {
                reject(JSON.stringify(error));

            })
        })
    }, 
    updatePhoneNumber({commit} , phone_number){
        return new Promise((resolve , reject) => {
            axios.post('/api/profile/updatephone' ,  { 'phone_number' : phone_number}).then( response => {
             if(response.data.code == '200'){
                commit('setUser' ,  response.data.user);
                resolve(response.data.msg);
             } else{
                 reject(response.data.error);
             }  
            }).catch( error => {
                reject(JSON.stringify(error));

            })
        }) 
    },
    updatePassword({commit} , password){
        return new Promise((resolve , reject) => {
            axios.post('/api/profile/updatepassword' ,  { 'password' : password}).then( response => {
             if(response.data.code == '200'){
                commit('setUser' ,  response.data.user);
                resolve(response.data.msg);
             } else{
                 reject(response.data.error);
             }  
            }).catch( error => {
                reject(JSON.stringify(error));

            })
        })
    }, 
    uploadProfile({commit} , fd){
        return new Promise((resolve , reject) => { 
            // commit('setUser' ,response.data );
            axios.post('/api/profile/updateimage',  fd).then((response) => {
                console.log(response)
                if(response.data.code == '200'){
                    commit('setUser' ,response.data.user );
                    resolve("Profile Image Updated Successfully.")
                }else{
                    reject(this.response.data.error);
                }
            }).catch( (error) => {
                reject(JSON.stringify(error))
            })

        });
    },
    updateImageDialogState({commit} , status){
      commit('setUpdateImageDialog' , status);  
    },
    savePassword(_ , data){
      return new Promise((resolve , reject) => {
          axios.post('/api/savepassword' ,{
              password: data.password,
              email: data.email,
              token: data.token
          } ).then(
              response => {

                if(response.data.code == '200'){
                    resolve("password Reset  Sucessfully. You can Now Login.")
                }else{
                    reject(response.data.error);
                }    
              }
          ).catch(
              err => {
                reject(err.message)
              }
          )
      })  
    },
    ressetPassword(_,email){
        return new Promise( (resolve , reject) => {
            axios.post('/api/resetpassword' , { email : email})
            .then( response => {
              if(response.data.code == '200'){
                  resolve("password Reset Link Sent, Sucessfully.")
              } 
              else if(response.data.code == '204'){
                  reject(response.data.message);
              } 
              else if(response.data.code == '400'){
                reject(response.data.error);
            } 
            else{
                reject("Server Error!!! very Unusual Right?");

            }
            }).catch(err => {
             console.log(err)
             reject(err.message)
            })
        })
    },
    registerUser(_ , user) {
        return new Promise(  (resolve , reject) => {
            axios.post('/api/register' , {
                email : user.email,
                name : user.username,
                password  : user.password
            }).then ( response => {
                console.log(response.data.code)
                if(response.data.code == '200'){
                    resolve("Registration Succesfull");
                }else{
                    reject(response.data.error.email[0])
                }
            }).catch( err => {
                reject(err.message)
            })
         })
    },
    attemptLogin({commit}){
        const currentUser = Moralis.User.current();
        if (currentUser ) {
            // do stuff with the user
            currentUser.address = currentUser.get('ethAddress');
            commit("setActiveUser" , currentUser);
        }
    } ,
    getUser({commit} ){
        axios.get('/api/user').then(
           response => {
               console.log(response.data);
                if(response.data.id){
                    commit('setUser' ,response.data );
                    commit('setLoggedIn' ,true);
                     
                }else{
                    window.location.href = '/login';
                }
              
            }
        ).catch(
            err => {
                console.log(err)
                window.location.href = '/login';
            }
        );
        
    },
    logout({commit}){
        return new Promise((resolve ) => {
            localStorage.setItem("user",JSON.stringify({}));
            commit('removeUser');
            resolve("successfully logged out");
        })
    },
    Moralislogout({commit} ){
        return new Promise((resolve ,  reject) => {
            Moralis.User.logOut().then(() => {
                commit('removeUser');
                resolve("successfully logged out")
              }).catch( error => reject(error));
        })
       
    },
    loginUser({commit}){
        return new Promise((resolve, reject) => {
            const currentUser = Moralis.User.current();
                if (currentUser) {
                    // do stuff with the user
                    commit("setActiveUser" , currentUser)
                } else {
                    // show the signup or login page
                    Moralis.Web3.authenticate().then(function (user) {
                        console.log(user.get('ethAddress'))
                        user.address =user.get('ethAddress');
                        commit("setActiveUser" , user)
                        resolve("User Login Successful.")
                          }).catch(error => {
                            reject(error)
                        });
                }
          
          })
      
    }
};
const mutations = {
    setUpdateImageDialog(state , status){
        state.updateImageDialog = status;
    },
    setLoggedIn (state , status) {
        state.loggedIn = status;
    }, 
    setActiveUser(state , user){
        state.user = user; 
        state.userAuthenticated =  true
    },
    removeUser(state ){
        state.user = {};
        state.userAuthenticated = false;
    }
};

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}